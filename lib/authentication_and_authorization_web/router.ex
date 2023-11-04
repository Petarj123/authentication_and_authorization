defmodule AuthenticationAndAuthorizationWeb.Router do
  use AuthenticationAndAuthorizationWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource, module: AuthenticationAndAuthorizationWeb.Auth.Guardian
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/api", AuthenticationAndAuthorizationWeb do
    pipe_through :api

    # Public endpoints
    post "/sign-up", UserController, :sign_up
    post "/sign-in", UserController, :sign_in
    post "/login", UserController, :login

    # Protected endpoints
    put "/auth/update-user", UserController, :update_user
  end
end
