defmodule Glados.Verify do
    
  alias Glados.Accounts.User
  alias Glados.{Email, Mailer, Token}
  alias GladosWeb.{Endpoint, Router.Helpers}

  def send_verification(%User{} = user) do
    token = Token.generate_new_account_token(user)
    verification_url = Helpers.user_url(Endpoint, :verify_email, token: token)
    
    Email.verification_email(user.name, user.email, verification_url)
    |> Mailer.deliver_now()
  end
        
  def send_verification(%User{} = user) do
    token = Token.generate_new_password_token(user)
    verification_url = Helpers.user_url(Endpoint, :change_password, token: token)
    
    Email.new_password_email(user.username, user.email, verification_url)
    |> Mailer.deliver_now()
  end
end