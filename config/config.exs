# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :weq,
  ecto_repos: [Weq.Repos.Weqdb1Repo, Weq.Repos.Weqdb2Repo]

# Configures the endpoint
config :weq, WeqWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "zC1gjEdI73gYbbkvOdYEofS29DIVEyYRx4zhb+GQdmSEInn45hAqv08DO1WdYQmQ",
  render_errors: [view: WeqWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Weq.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
