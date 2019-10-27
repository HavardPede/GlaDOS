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
      html_body: "<strong>Takk for at du tar interesse for ESLG, #{name}.</strong>",
      html_body: "Følg denne lenken for å verifisere din profil: #{verification_url}"
    )
  end

  def new_password_email(username, email, verification_url) do
    new_email(
      to: email,
      from: "noreply@eslgcrew.no",
      subject: "Sett nytt passord",
      html_body: "Brukernavn: <strong>#{username}</strong>",
      html_body: "Følg denne lenken for å sette et nytt passord for din profil: #{verification_url}"
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
