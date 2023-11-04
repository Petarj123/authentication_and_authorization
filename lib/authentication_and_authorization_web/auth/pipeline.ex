defmodule AuthenticationAndAuthorizationWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline, otp_app: :authentication_and_authorization,
                              module: AuthenticationAndAuthorization.Guardian,
                              error_handler: AuthenticationAndAuthorizationWeb.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
