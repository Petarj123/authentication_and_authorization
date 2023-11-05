defmodule AuthenticationAndAuthorization.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :email, :first_name, :last_name, :username]}
  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password, :string
    field :username, :string

    timestamps(type: :utc_datetime)
  end

  @password_min_length 8
  @password_max_length 100
  @username_min_length 6
  @username_max_length 20
  @email_min_length 3
  @email_max_length 50
  @email_regex ~r/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/
  @password_regex ~r/^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[_\W]).{8,100}$/

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :username, :password])
    |> validate_required([:first_name, :last_name, :email, :username, :password])
    |> validate_format(:email, @email_regex, message: "is not a valid email address")
    |> validate_format(:password, @password_regex, message: "must include at least one uppercase letter, one lowercase letter, one number, and one special character")
    |> validate_length(:first_name, max: 30)
    |> validate_length(:last_name, max: 30)
    |> validate_length(:username, min: @username_min_length, max: @username_max_length)
    |> validate_length(:email, min: @email_min_length, max: @email_max_length)
    |> validate_length(:password, min: @password_min_length, max: @password_max_length)
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> hash_password()
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password, Bcrypt.hash_pwd_salt(password))
      _ ->
        changeset
    end
  end
end
