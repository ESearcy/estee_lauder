defmodule EsteeLauder.FoodTrucksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EsteeLauder.FoodTrucks` context.
  """

  @doc """
  Generate a food_truck.
  """
  def food_truck_fixture(attrs \\ %{}) do
    {:ok, food_truck} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> EsteeLauder.FoodTrucks.create_food_truck()

    food_truck
  end
end
