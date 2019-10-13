defmodule Glados.Accounts.Auth do
  alias Glados.Accounts.{Encryption, User}
  alias Glados.Repo

  @doc """
  Function to login a user.
  Fetches user from db then validates if the given password matches with the hash stored.
  Returns ok tuple on valid password
  """
  def login(params) do
    user = Repo.get_by(User, username: String.downcase(params["username"]))

    case authenticate(user, params["password"]) do
      true -> {:ok, user}
      _ -> {:error, "Invalid password"}
    end
  end

  # Checks the password against the hash in the db.
  defp authenticate(nil, _password), do: nil

  defp authenticate(user, password) do
    case Encryption.validate_password(user, password) do
      {:ok, authenticated_user} ->
        authenticated_user.username == user.username

      _ ->
        nil
    end
  end

  @doc """
  Checks to see if there is a current user stored in the connection
  """
  def signed_in?(conn) do
    !!Plug.Conn.get_session(conn, :current_user_id)
  end
end
