# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :glasnost,
  ecto_repos: [Glasnost.Repo]

# Configures the endpoint
config :glasnost, Glasnost.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "IlPcXpQ1HeGwB09HaGUTGosT6dtEPHqFGNLP41CXnEtdLZj985A5mVhpJXUegvrk",
  render_errors: [view: Glasnost.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Glasnost.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :template_engines,
  pug: PhoenixExpug.Engine


config :ex_golos,
  url: System.get_env("GOLOS_URL"),
  activate_stage_sup: true

config :steemex,
  url: System.get_env("STEEM_URL"),
  activate_stage_sup: true

config :glasnost, Glasnost.Repo,
  adapter: Ecto.Adapters.Mnesia

config :ecto_mnesia,
  host: {:system, :atom, "MNESIA_HOST", Kernel.node()},
  storage_type: {:system, :atom, "MNESIA_STORAGE_TYPE", :ram_copies}

config :mnesia,
  dir: 'priv/data/mnesia' # Make sure this directory exists

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
