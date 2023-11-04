import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :authentication_and_authorization, AuthenticationAndAuthorization.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "authentication_and_authorization_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :authentication_and_authorization, AuthenticationAndAuthorizationWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "b5EHVPh4EMSxfWIiP7PrY0vmpA2w8cyFz4AUYYWYuhSjJ7+04iUFebdh4zGsVZCR",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
