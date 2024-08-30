defmodule EsteeLauder.FoodTruck.Supervisor do
  use Supervisor

  def start_link(state) do
    Supervisor.start_link(__MODULE__, state)
  end

  @impl true
  def init(state \\ %{}) do
    IO.inspect("Starting FoodTruck Supervisor (cache & worker)")

    children = [
      {Cachex, name: :food_trucks},
      {EsteeLauder.FoodTruck.Worker, state}
    ]

    Supervisor.init(children, strategy: :one_for_one, name: EsteeLauder.FoodTruck.Supervisor)
  end
end
