defmodule Glados.EmailSender do
  @moduledoc """
  Handles outgoing verification emails
  """

  alias Glados.Accounts.User
  alias Glados.{Email, Mailer, Token}
  alias GladosWeb.{Endpoint, Router.Helpers}

  @doc """
  Sends out an email containing a url for verifying an account.
  """
  def send_verification(%User{} = user) do
    token = Token.generate_new_account_token(user)
    verification_url = Helpers.account_url(Endpoint, :verify_email, token: token)

    Email.verification_email(user.name, user.email, verification_url)
    |> Mailer.deliver_now()
  end

  @doc """
  Sends out an email containing a url for resetting a password.
  """
  def send_password_reset(%User{} = user) do
    token = Token.generate_new_password_token(user)
    verification_url = Helpers.account_url(Endpoint, :change_password, token: token)

    Email.new_password_email(user.username, user.email, verification_url)
    |> Mailer.deliver_now()
  end
end
