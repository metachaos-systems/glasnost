use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :glasnost, GlasnostWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# config :hound, driver: "phantomjs"

# Configure your database
config :glasnost, Glasnost.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "glasnost_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "35432"
