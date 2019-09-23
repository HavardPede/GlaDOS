defmodule Glados.Email do
  import Bamboo.Email

  @moduledoc """
  Email templates for sending email.
  """

  def verification_email(name, email, verification_url) do
    new_email(
      to: email,
      from: "noreply@eslgcrew.no",
      subject: "Bruker verifisering",
      html_body: "<strong>Takk for at du tar interesse for ESLG, #{name}</strong>",
      text_body:
        "Følg denne lenken for å verifisere din profil: <a href=<%= verification_url %>>glados.eslgcrew.no</a>"
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
