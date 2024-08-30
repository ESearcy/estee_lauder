defmodule EsteeLauderWeb.FoodTruckJSON do
  @doc """
  Renders a list of food_trucks.
  """
  def index(%{food_trucks: food_trucks}) do
    %{data: for(food_truck <- food_trucks, do: data(food_truck))}
  end

  @doc """
  Renders a single food_truck.
  """
  def show(%{food_truck: food_truck}) do
    %{data: data(food_truck)}
  end

  defp data({location_id, food_truck}) do
    %{
      location_id: location_id,
      name: food_truck.applicant,
      location_description: food_truck.location_description,
      food_items: food_truck.food_items,
      schedule: "At Location till #{food_truck.expiration_date}"
    }
  end
end
