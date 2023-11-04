# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :authentication_and_authorization,
  ecto_repos: [AuthenticationAndAuthorization.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :authentication_and_authorization, AuthenticationAndAuthorizationWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [json: AuthenticationAndAuthorizationWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: AuthenticationAndAuthorization.PubSub,
  live_view: [signing_salt: "M8iTDQcE"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Guardian config
config :authentication_and_authorization, AuthenticationAndAuthorization.Guardian,
    issuer: "authentication_and_authorization",
    secret_key: "8qVqL7mXwU2fIn+Q9XbdBj6mkv5fVc6zXh3hXnyh0J3JoY/A2uh6LfkwkDdqLSn/"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
