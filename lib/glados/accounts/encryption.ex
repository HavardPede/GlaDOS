defmodule Glados.Accounts.Encryption do
  @moduledoc """
  Handles password encryption and validation.
  """

  alias Comeonin.Bcrypt
  alias Glados.Accounts.User

  @doc """
  Given a password, hash it, using a salt.
  """
  def hash_password(password) do
    Bcrypt.hashpwsalt(password)
  end

  @doc """
  Given a user and a string, check if the string is the password for the user account.
  """
  def validate_password(%User{} = user, password), do: Bcrypt.check_pass(user, password)
end
