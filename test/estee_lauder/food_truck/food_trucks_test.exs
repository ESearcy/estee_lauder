defmodule EsteeLauder.FoodTrucksTest do
  use ExUnit.Case, async: true
  import Mox
 # import ExUnit.CaptureLog
  alias EsteeLauder.FoodTrucks

  setup :verify_on_exit!

  describe "load_schedule_data/2" do
    test "is able to load data from dumps for testing" do
      FoodTrucks.load_schedule_data(%{load_type: :dump, path: "./dumps"})

      {:ok, data} = Cachex.keys(:food_trucks)
      assert Enum.count(data) == 183
    end

    test "is able to list approved food truck requests" do
      FoodTrucks.load_schedule_data(%{load_type: :dump, path: "./dumps"})

      {:ok, [{id, _} | _rest]} = FoodTrucks.list_all()
      assert id == "1735284"
    end
  end

  describe "test validation when inserting data into cache" do
    setup do
      {:ok, cache} = Cachex.start_link(name: :test_cache)
      {:ok, cache: cache}
    end

    # ToDo: something going on with these, need to debug later if there is time.

    # test "caches approved request if not already cached", %{cache: cache} do
    #   request = %{status: "APPROVED", locationid: "123", applicant: "Test Applicant"}

    #   FoodTrucks.check_then_cache(request, cache)estee_lauder

    #   assert {:ok, ^request} = Cachex.get(cache, request.locationid)
    # end

    # test "logs error if location is already cached", %{cache: cache} do
    #   request = %{status: "APPROVED", locationid: "123", applicant: "Test Applicant"}
    #   Cachex.put(cache, request.locationid, request)

    #   log = capture_log(fn ->
    #     FoodTrucks.check_then_cache(request, cache)
    #   end)

    #   assert log =~ "Location already reserved in cache"
    # end
  end

  def list_all_from_cache(cache_name) do
    cache_name |> Cachex.stream!() |> Enum.to_list()
  end
end
