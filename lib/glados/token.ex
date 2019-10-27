defmodule Glados.Token do

  alias Glados.Accounts.User

  @moduledoc """
  Handles creating and validating tokens.
  """

  @account_verification_salt "Salt og pepper, Baby!!"
  @set_new_password_salt "sprinkle some 5a1t"

  def generate_new_account_token(%User{id: user_id}) do
    Phoenix.Token.sign(GladosWeb.Endpoint, @account_verification_salt, user_id)
  end

  def verify_new_account_token(token) do
    # tokens that are older than a day should be invalid
    max_age = 86_400
    Phoenix.Token.verify(GladosWeb.Endpoint, @account_verification_salt, token, max_age: max_age)
  end

  def generate_new_password_token(%User{id: user_id}) do
    Phoenix.Token.sign(GladosWeb.Endpoint, @set_new_password_salt, user_id)
  end

  def set_new_password_token(token) do
    # tokens that are older than 30 minutes should be invalid
    max_age = 1_800
    Phoenix.Token.verify(GladosWeb.Endpoint, @set_new_password_salt, token, max_age: max_age)
  end
end
