defmodule AuthenticationAndAuthorizationWeb.UserController do
  use AuthenticationAndAuthorizationWeb, :controller
  alias AuthenticationAndAuthorization.Accounts

  def create_user(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        # User created successfully
        conn
        |> put_status(:created)
        |> json(%{message: "User created successfully"}) # Sends a 201 status with a success message and user ID

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset_errors(changeset)}) # Sends a 422 status with error messages
    end
  end

  defp changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end


end
