defmodule EsteeLauder.FoodTrucks.Supervisor do
  use Supervisor

  def start_link(state) do
    Supervisor.start_link(__MODULE__, state)
  end

  require Logger

  @impl true
  def init(state \\ %{}) do
    Logger.info("Starting FoodTruck Supervisor (cache & worker)")

    children = [
      {Cachex, name: :food_trucks},
      {EsteeLauder.FoodTrucks.Worker, state}
    ]

    Supervisor.init(children, strategy: :one_for_one, name: EsteeLauder.FoodTrucks.Supervisor)
  end
end
