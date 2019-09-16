defmodule Glados.Email do
  import Bamboo.Email

  @moduledoc """
  Email templates for sending email.
  """

  def send_account_verification_email(user, verification_url) do
    new_email(
      to: user,
      from: "noreply@eslgcrew.no",
      subject: "Account verification",
      html_body: "<strong>Thanks for joining GLaDOS.</strong>",
      text_body:
        "Follow this link to verify your account: <a href=<%= verification_url %>>glados.eslgcrew.no</a>"
    )
  end

  def welcome_email do
    new_email(
      to: "havardpede@gmail.com",
      from: "noreply@eslgcrew.no",
      subject: "Welcome to the app.",
      html_body: "<strong>Thanks for joining GLaDOS.</strong>",
      text_body: "Thanks for joining!"
    )
  end
end
