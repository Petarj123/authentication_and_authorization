defmodule AuthenticationAndAuthorization.Repo do
  use Ecto.Repo,
    otp_app: :authentication_and_authorization,
    adapter: Ecto.Adapters.Postgres
end
