use Mix.Config

config :example, ExampleWeb.Endpoint,
  http: [:inet6, port: {:system, "PORT"}],
  url: [host: {:system, "WEB_HOST"}, port: {:system, "PORT"}],
  root: ".",
  cache_static_manifest: "priv/static/cache_manifest.json",
  version: Application.spec(:example, :vsn)

# Do not print debug messages in production
config :logger, level: :info

# Force SSL
config :example, ExampleWeb.Endpoint, force_ssl: [hsts: true]

# Start all phoenix endpoints on application boot
config :phoenix, :serve_endpoints, true

# The rest of the database configuration is in rel/config/prod.exs
config :example, Example.Repo,
  adapter: Ecto.Adapters.Postgres,
  ssl: true
