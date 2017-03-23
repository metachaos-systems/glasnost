use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :glasnost, Glasnost.Web.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :glasnost, Glasnost.Repo,
  adapter: Ecto.Adapters.Mnesia
  # username: "postgres",
  # password: "postgres",
  # database: "glasnost_test",
  # hostname: "localhost",
  # pool: Ecto.Adapters.SQL.Sandbox
