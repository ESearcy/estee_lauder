defmodule EsteeLauderWeb.FoodTruckControllerTest do
  use EsteeLauderWeb.ConnCase

  alias EsteeLauder.FoodTrucks


  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all food_trucks", %{conn: conn} do

      FoodTrucks.load_schedule_data(%{load_type: :dump, path: "./dumps"})

      conn = get(conn, ~p"/api/food_trucks")
      response = json_response(conn, 200)["data"]
      assert  Enum.count(response) == 183
    end
  end
end
