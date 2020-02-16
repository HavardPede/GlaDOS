defmodule Glados.Email do
  @moduledoc """
  Email templates for sending email.
  """

  import Bamboo.Email
  @from {"ESLG Glados", "noreply@eslgcrew.no"}

  def verification_email(name, email, verification_url) do
    new_email(
      to: email,
      from: @from,
      subject: "Bruker verifisering",
      html_body: "<strong>Takk for at du tar interesse for ESLG, #{name}.</strong>",
      html_body: "Følg denne lenken for å verifisere din profil: #{verification_url}"
    )
  end

  def new_password_email(username, email, verification_url) do
    new_email(
      to: email,
      from: @from,
      subject: "Sett nytt passord",
      html_body: "Brukernavn: <strong>#{username}</strong>",
      html_body:
        "Følg denne lenken for å sette et nytt passord for din profil: #{verification_url}"
    )
  end
end
