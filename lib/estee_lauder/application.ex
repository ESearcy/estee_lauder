defmodule EsteeLauder.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    IO.inspect(Application.get_env(:estee_lauder, EsteeLauder.Repo), label: "Database Config")
    :ok = Application.ensure_started(:tls_certificate_check)

    :opentelemetry_cowboy.setup()
    OpentelemetryPhoenix.setup(adapter: :cowboy2)
    OpentelemetryEcto.setup([:estee_lauder, :repo])

    children = [
      EsteeLauderWeb.Telemetry,
      EsteeLauder.Repo,
      {DNSCluster, query: Application.get_env(:estee_lauder, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: EsteeLauder.PubSub},
      EsteeLauder.FoodTruck.Supervisor,
      # Start the Finch HTTP client for sending emails
      {Finch, name: EsteeLauder.Finch},
      # Start a worker by calling: EsteeLauder.Worker.start_link(arg)
      # {EsteeLauder.Worker, arg},
      # Start to serve requests, typically the last entry
      EsteeLauderWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EsteeLauder.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EsteeLauderWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
