defmodule AuthenticationAndAuthorizationWeb.UserController do
  use AuthenticationAndAuthorizationWeb, :controller
  alias AuthenticationAndAuthorizationWeb.UserManager.UserManager

  def sign_up(conn, %{"user" => user_params}) do
    case UserManager.sign_up(user_params) do
      {:ok, _user} ->
        conn
        |> put_status(:created)
        |> json(%{message: "User created successfully"})

        {:error, changeset} ->
          errors = Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
            Enum.reduce(opts, msg, fn {key, value}, acc ->
              String.replace(acc, "%{#{key}}", to_string(value))
            end)
          end)

          conn
          |> put_status(:unprocessable_entity)
          |> json(%{errors: errors})
    end
  end

  def sign_in(conn, %{"user" => user_params}) do
    with {:ok, _user} <- UserManager.sign_in(user_params["username"] || user_params["email"], user_params["password"]) do
      conn
      |> put_status(:ok)
      |> json(%{message: "Signed in successfully."})
    else
      {:error, error_message} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: error_message})
    end
  end

  def login(conn, %{"user" => user_params}) do
    case UserManager.login(user_params["username"] || user_params["email"], user_params["password"]) do
      {:ok, %{user: user, token: token}} ->
        user_data = %{
          id: user.id,
          first_name: user.first_name,
          last_name: user.last_name,
          username: user.username,
          email: user.email,
          password: user.password
        }


        conn
        |> put_status(:ok)
        |> json(%{
          user: user_data,
          token: token
        })

      {:error, reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: reason})
    end
  end


  def update_user(conn, %{"user" => user_params}) do
    # Extract the Bearer token from the Authorization header
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        case UserManager.update_user(token, user_params) do
          {:ok, updated_user} ->
            conn
            |> put_status(:ok)
            |> json(%{user: updated_user})

          {:error, changeset} when is_map(changeset) ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{errors: changeset_errors(changeset)})

          {:error, reason} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: to_string(reason)})
        end
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
