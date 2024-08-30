defmodule EsteeLauderWeb.FoodTruckController do
  use EsteeLauderWeb, :controller

  alias EsteeLauder.FoodTrucks

  action_fallback EsteeLauderWeb.FallbackController

  def index(conn, _params) do
    {:ok, food_trucks} = FoodTrucks.list_all_taco_trucks()
    render(conn, :index, food_trucks: food_trucks)
  end
end
