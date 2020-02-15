defmodule Glados.Accounts.Encryption do
  @moduledoc """
  Handles password encryption and validation.
  """

  alias Glados.Accounts.User

  @doc """
  Given a password, hash it, using a salt.
  """
  def hash_password(password) do
    Bcrypt.hash_pwd_salt(password)
  end

  @doc """
  Given a user and a string, check if the string is the password for the user account.

  ## example
    validate_password(:a_valid_user, :valid_password)
    {:ok, :a_valid_user}

    validate_password(:a_valid_user, :invalid_password)
    {:error, "invalid password"}
  """
  def validate_password(%User{} = user, password), do: Bcrypt.check_pass(user, password)

  @doc """
  Checks if a password is valid for a given user.
  """
  def valid_password?(user, password) do
    case validate_password(user, password) do
      {:ok, _user} -> true
      {:error, _user} -> false
    end
  end
end

defmodule Glados.Accounts.MockEncryption do
  @moduledoc """
  Mocks handling of password encryption and validation.
  This is used for testing purposes to reduce testing time.
  """

  alias Glados.Accounts.User

  def hash_password(password), do: password

  def validate_password(%User{} = user, password) do
    if user.encrypted_password == password do
      {:ok, user}
    else
      {:error, "invalid password"}
    end
  end

  def valid_password?(user, password) do
    case validate_password(user, password) do
      {:ok, _user} -> true
      {:error, _user} -> false
    end
  end
end
