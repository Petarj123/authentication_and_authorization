defmodule AuthenticationAndAuthorizationWeb.Auth.Authentication do
  alias AuthenticationAndAuthorizationWeb.Auth.Guardian
  alias AuthenticationAndAuthorization.Accounts

  def sign_up(user_params) do
    Accounts.create_user(user_params)
  end

  def sign_in(username_or_email, password) do
    case Accounts.get_user_by_username_or_email(username_or_email) do
      nil ->
        {:error, "Invalid username/email or password."}

      user ->
        if Accounts.verify_password(user, password) do
          {:ok, user}
        else
          {:error, "Invalid username/email or password."}
        end
    end
  end

  def login(username_or_email, password) do
    case Accounts.get_user_by_username_or_email(username_or_email) do
      nil ->
        {:error, "Invalid username/email or password."}

      user ->
        if Accounts.verify_password(user, password) do
          try do
            {:ok, _user, token} = Guardian.create_token(user)
            {:ok, %{user: user, token: token}}
          rescue
            _e in Guardian.Error -> {:error, "Failed to create token."}
          end
        else
          {:error, "Invalid username/email or password."}
        end
    end
  end


  def update_user(token, user_params) do
    case Guardian.extract_id_from_token(token) do
      {:ok, id} ->
        case Accounts.get_user!(id) do
          nil -> {:error, "User not found"}
          user -> Accounts.update_user(user, user_params)
        end
      {:error, reason} -> {:error, reason}
    end
  end
end
