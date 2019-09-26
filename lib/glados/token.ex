defmodule Glados.Token do
  @moduledoc """
  Handles creating and validating tokens.
  """

  @account_verification_salt "Salt og pepper, Baby!!"

  def generate_new_account_token(%Glados.Accounts.User{id: user_id}) do
    Phoenix.Token.sign(GladosWeb.Endpoint, @account_verification_salt, user_id)
  end

  def verify_new_account_token(token) do
    # tokens that are older than a day should be invalid
    max_age = 86_400
    Phoenix.Token.verify(GladosWeb.Endpoint, @account_verification_salt, token, max_age: max_age)
  end
end
