defmodule AuthenticationAndAuthorization.Accounts do
  import Ecto.Query, warn: false
  alias Hex.API.User
  alias AuthenticationAndAuthorization.Repo

  alias AuthenticationAndAuthorization.Accounts.User


  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)


  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def get_user_by_username_or_email(username_or_email) do
    Repo.get_by(User, [username: username_or_email]) || Repo.get_by(User, [email: username_or_email])
  end

  def verify_password(%User{password: password}, attempted_password) do
    Bcrypt.verify_pass(attempted_password, password)
  end
end
