defmodule AuthenticationAndAuthorizationWeb.Router do
  use AuthenticationAndAuthorizationWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", AuthenticationAndAuthorizationWeb do
    pipe_through :api
  end
end
