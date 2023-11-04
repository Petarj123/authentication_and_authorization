defmodule AuthenticationAndAuthorization.Guardian do
  use Guardian, otp_app: :authentication_and_authorization
  alias AuthenticationAndAuthorization.Accounts

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(%{"sub" => id}) do
    user = Accounts.get_user!(id)
    {:ok, user}
  rescue
    Ecto.NoResultsError -> {:error, :resource_not_found}
  end

  def create_token(user) do
    {:ok, token, _claims} = encode_and_sign(user)
    {:ok, user, token}
  end

  def extract_id_from_token(token) do
    case decode_and_verify(token) do
      {:ok, claims} ->
        {:ok, claims["sub"]}
      {:error, reason} ->
        {:error, reason}
    end
  end
end
