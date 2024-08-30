import Config

# Configure your database
config :estee_lauder, EsteeLauder.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "estee_lauder_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we can use it
# to bundle .js and .css sources.
config :estee_lauder, EsteeLauderWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "KKvGgdTj2FrWOMP5JYOpZu1dZo2mddqNkO9z/sRC7d7e51+8Dny8gUUMSZ77BOb5",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:estee_lauder, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:estee_lauder, ~w(--watch)]}
  ]

# tells caches to use dumps and what directory they are in
config :estee_lauder, :caching, %{load_type: :live}
# config :estee_lauder, :caching, %{load_type: :dump, path: "./dumps"}

# Watch static and templates for browser reloading.
config :estee_lauder, EsteeLauderWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/estee_lauder_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

# Enable dev routes for dashboard and mailbox
config :estee_lauder, dev_routes: true

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  # Include HEEx debug annotations as HTML comments in rendered markup
  debug_heex_annotations: true,
  # Enable helpful, but potentially expensive runtime checks
  enable_expensive_runtime_checks: true

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false
