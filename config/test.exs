use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :example, ExampleWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

if System.get_env("DATABASE_URL") do
  # For CI
  config :example, Example.Repo,
    adapter: Ecto.Adapters.Postgres,
    url: System.get_env("DATABASE_URL"),
    pool: Ecto.Adapters.SQL.Sandbox
else
  config :example, Example.Repo,
    adapter: Ecto.Adapters.Postgres,
    username: System.get_env() |> Map.get("USER", "postgres"),
    password: "",
    database: "example_test",
    hostname: "localhost",
    pool: Ecto.Adapters.SQL.Sandbox
end
