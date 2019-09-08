defmodule Glados.Accounts.Encryption do
  alias Comeonin.Bcrypt
  alias Glados.Accounts.User

  def hash_password(password) do
    Bcrypt.hashpwsalt(password)
  end

  def validate_password(%User{} = user, password), do: Bcrypt.check_pass(user, password)
end
