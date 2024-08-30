defmodule EsteeLauder.FoodTrucks do
  @cache :food_trucks

  require Logger
  require OpenTelemetry.Tracer, as: Tracer

  def load_schedule_data(%{load_type: :none}) do
    Logger.info("No data loaded for food truck cache")
  end

  def load_schedule_data(%{load_type: :dump, path: path}) do
    Cachex.load(@cache, "#{path}/food_trucks")
  end

  @doc """
  it doesn't look like multiple trucks can be at the same location at the same time, no duplicates seen in the data.
  here we filter out any non approved schedule requests and setup our location -> reservation_details cache values.
  """
  def load_schedule_data(%{load_type: :live}, cache \\ @cache) do
    Tracer.with_span "Food Trucks Load Data" do
      Cachex.clear(cache)

      case EsteeLauder.FoodTrucks.FoodTruckAPI.fetch_data() do
        {:ok, schedule_requests} ->
          schedule_requests
          |> Enum.each(&check_then_cache(&1, cache))

        {:error, reason} ->
          Logger.error("Failed to fetch data: #{inspect(reason)}")
      end
    end
  end

  def check_then_cache(%{status: "APPROVED"} = request, cache) do
    span_attribs = %{locationid: request.locationid, applicant: request.applicant}

    Tracer.with_span "caching", span_attribs do
      case Cachex.get(cache, request.locationid) do
        {:ok, nil} ->
          Cachex.put(cache, request.locationid, request)

        {:ok, existing} ->
          Logger.error("Location already reserved in cache #{inspect(existing)}")
      end
    end
  end

  def check_then_cache(_data, _cache), do: nil

  def list_all(cache \\ @cache) do
    {:ok, Cachex.stream!(cache) |> Enum.map(fn {_, id, _, _, data} -> {id, data} end)}
  end
end
