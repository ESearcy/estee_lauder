defmodule EsteeLauder.FoodTrucks.FoodTruckAPITest do
  use ExUnit.Case, async: true
  import Mox
  alias EsteeLauder.FoodTrucks.FoodTruckAPI

  setup :verify_on_exit!

  @csv_data """
  locationid,Applicant,FacilityType,cnn,LocationDescription,Address,blocklot,block,lot,permit,Status,FoodItems,X,Y,Latitude,Longitude,Schedule,dayshours,NOISent,Approved,Received,PriorPermit,ExpirationDate,Location,Fire Prevention Districts,Police Districts,Supervisor Districts,Zip Codes,Neighborhoods (old)
  1,Test Truck,Truck,123,Test Location,123 Test St,1234,123,4,12345,APPROVED,Test Food,0,0,37.7749,-122.4194,Test Schedule,Test Hours,,2021-01-01,2020-01-01,2021-01-01,POINT (-122.4194 37.7749),1,1,1,94103,Test Neighborhood
  """

  @expected_struct %EsteeLauder.FoodTrucks.FoodTruck{
    address: "123 Test St",
    applicant: "Test Truck",
    approved: "2021-01-01",
    block: "123",
    blocklot: "1234",
    cnn: "123",
    dayshours: "Test Hours",
    expiration_date: "POINT -122.4194 37.7749",
    facility_type: "Truck",
    fire_prevention_districts: "1",
    food_items: "Test Food",
    id: nil,
    inserted_at: nil,
    latitude: "37.7749",
    location: "1",
    location_description: "Test Location",
    locationid: "1",
    longitude: "-122.4194",
    lot: "4",
    neighbors_old: nil,
    noi_sent: nil,
    permit: "12345",
    police_districts: "1",
    prior_permit: "2021-01-01",
    received: "2020-01-01",
    schedule: "Test Schedule",
    status: "APPROVED",
    supervisor_districts: "94103",
    updated_at: nil,
    x: "0",
    y: "0",
    zip_codes: "Test Neighborhood"
  }

  describe "fetch_data/0" do
    test "successfully fetches and parses data" do
      # Mock the HTTP request
      ReqMock
      |> expect(:new, fn _opts -> :mock_request end)
      |> expect(:get, fn :mock_request -> {:ok, %Req.Response{status: 200, body: @csv_data}} end)

      # Call the function
      assert {:ok, [@expected_struct]} = FoodTruckAPI.fetch_data(ReqMock)
    end

    test "returns error when HTTP request fails" do
      # Mock the HTTP request
      ReqMock
      |> expect(:new, fn _opts -> :mock_request end)
      |> expect(:get, fn :mock_request -> {:error, :timeout} end)

      # Call the function
      assert {:error, "failed to make HTTP request timeout"} = FoodTruckAPI.fetch_data(ReqMock)
    end

    test "returns error when response status is not 200" do
      # Mock the HTTP request
      ReqMock
      |> expect(:new, fn _opts -> :mock_request end)
      |> expect(:get, fn :mock_request ->
        {:ok, %Req.Response{status: 500, body: "Internal Server Error"}}
      end)

      # Call the function
      assert {:error, "failed to fetch data"} = FoodTruckAPI.fetch_data(ReqMock)
    end
  end
end
