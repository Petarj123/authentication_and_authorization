defmodule AuthenticationAndAuthorizationWeb.ErrorHandler do
  import Plug.Conn

  def unauthenticated(conn, _params) do
    conn
    |> put_status(:unauthorized)
    |> halt()
  end

  def unauthorized(conn, _params) do
    conn
    |> put_status(:forbidden)
    |> halt()
  end
end
