defmodule EsteeLauder.Repo do
  use Ecto.Repo,
    otp_app: :estee_lauder,
    adapter: Ecto.Adapters.Postgres
end
