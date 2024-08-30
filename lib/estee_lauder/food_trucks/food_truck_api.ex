defmodule EsteeLauder.FoodTruck.FoodTruckAPI do
  @moduledoc """
  This module is meant solely to fetch the food truck data.
  With any authenticated API, we'd store the credentials in our env vars and load them through the application configuration but that's not needed here.
  """

  alias Httpoison
  require OpenTelemetry.Tracer, as: Tracer
  require Logger

  @csv_download_endpoint "https://data.sfgov.org/api/views/rqzj-sfat/rows.csv"
  @expected_column_header "locationid,Applicant,FacilityType,cnn,LocationDescription,Address,blocklot,block,lot,permit,Status,FoodItems,X,Y,Latitude,Longitude,Schedule,dayshours,NOISent,Approved,Received,PriorPermit,ExpirationDate,Location,Fire Prevention Districts,Police Districts,Supervisor Districts,Zip Codes,Neighborhoods (old)"
  @http_status_ok 200

  def fetch_data(http_client \\ Req) do
    Tracer.with_span "fetch data from https://data.sfgov.org" do
      case http_client.new(
             url: @csv_download_endpoint,
             finch: EsteeLauder.Finch,
             retry: :safe_transient
           )
           |> http_client.get() do
        {:ok, response} ->
          case response.status do
            @http_status_ok ->
              records = process_response_body(response.body)
              {:ok, records}

            _ ->
              Tracer.add_event("error fetching data from https://data.sfgov.org", %{
                status: response.status
              })

              Logger.error("Error fetching data from https://data.sfgov.org")
              {:error, "failed to fetch data"}
          end

        {:error, reason} ->
          Tracer.add_event("error making HTTP request", %{reason: reason})
          Logger.error("Error making HTTP request: #{inspect(reason)}")
          {:error, "failed to make HTTP request #{reason}"}
      end
    end
  end

  defp process_response_body(body) do
    body
    |> map_rows_to_columns
    |> Enum.map(fn request ->
      request
      |> EsteeLauder.FoodTruck.transform_keys()
      |> cast_to_struct()
    end)
  end

  @doc """
  This function will take the response body of the csv and convert it into a list of maps.

  the only reason its not private is for unit testing.
  """
  def map_rows_to_columns(text_blob) do
    Tracer.with_span "parsing fetched text blob to structs" do
      [header | rows] = String.split(text_blob, "\n", trim: true)
      columns = String.split(header, ",", trim: true)

      if header != @expected_column_header do
        Tracer.add_event("header row changed", %{header_row: header})
        Logger.error("Expected column headers to be #{@expected_column_header} but got #{header}")
        raise "Expected column headers to be #{@expected_column_header} but got #{header}"
      end

      rows
      |> Enum.map(&split_and_cleanup(&1))
      |> Enum.map(&(Enum.zip(columns, &1) |> Enum.into(%{})))
    end
  end

  defp split_and_cleanup(string) do
    string
    |> String.split(",")
    |> Enum.map(&cleanup/1)
  end

  defp cleanup(string) do
    string
    |> String.replace("\"", "")
    |> String.replace("\)", "")
    |> String.replace("\(", "")
    |> String.trim()
  end

  defp cast_to_struct(details) do
    EsteeLauder.FoodTruck.changeset(%EsteeLauder.FoodTruck{}, details)
    |> Ecto.Changeset.apply_changes()
  end
end
