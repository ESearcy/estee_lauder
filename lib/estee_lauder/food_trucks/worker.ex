defmodule EsteeLauder.FoodTruck.Worker do
  use GenServer
  require Logger

  @thirty_mins 30 * 60 * 1000

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(_state \\ %{}) do
    {:ok, config} = Application.fetch_env(:estee_lauder, :caching)
    {:ok, config, {:continue, :load_data}}
  end

  @impl true
  def handle_continue(:load_data, config) do
    case config.load_type do
      :none ->
        Logger.info("No caching configured")

      :dump ->
        EsteeLauder.FoodTrucks.load_schedule_data(config)

      :live ->
        EsteeLauder.FoodTrucks.load_schedule_data(config)
        schedule_sync(@thirty_mins)
    end

    {:noreply, config}
  end

  defp schedule_sync(time) do
    Process.send_after(self(), :fetch, time)
  end

  @impl true
  def handle_info(:fetch, config) do
    Logger.info("#{inspect(DateTime.utc_now())} fetching foodtruck schedule")
    EsteeLauder.FoodTrucks.load_schedule_data(config)
    schedule_sync(@thirty_mins)
    {:noreply, config}
  end
end
