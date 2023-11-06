defmodule AuthenticationAndAuthorizationWeb.Auth.Pipeline do
  alias AuthenticationAndAuthorizationWeb.Auth.ErrorHandler
  use Guardian.Plug.Pipeline, otp_app: :authentication_and_authorization,
                              module: AuthenticationAndAuthorizationWeb.Auth.Guardian,
                              error_handler: ErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
