defmodule GladosWeb.SessionController do
  @moduledoc """
  Controller for handling actions related to a login session.
  """

  use GladosWeb, :controller

  import Phoenix.HTML.Link
  alias Glados.Accounts.Auth
  alias GladosWeb.Endpoint

  @doc """
  Route to display login page
  """
  def new(conn, _params) do
    render(conn, "new.html", layout: {GladosWeb.LayoutView, "dark_bg.html"})
  end

  @doc """
  Route to generate a new login session
  """
  def create(conn, %{"session" => auth_params}) do
    case Auth.login(auth_params) do
      {:ok, user} ->
        if user.verified do
          conn
          |> put_session(:current_user_id, user.id)
          |> put_session(:account_type, user.account_type)
          |> configure_session(renew: true)
          |> redirect(to: Routes.member_path(Endpoint, :index))
        else
          conn
          |> put_session(:unverified_user, user.id)
          |> put_flash(
            :error,
            [
              "Du er ikke verifisert!  ",
              link("Klikk her for å sende en ny email",
                to: Routes.account_path(Endpoint, :send_email_verification),
                class: "dark_blue"
              ),
              "."
            ]
          )
          |> render("new.html", layout: {GladosWeb.LayoutView, "dark_bg.html"})
        end

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Et problem oppstod med ditt brukernavn/passord")
        |> redirect(to: Routes.session_path(Endpoint, :new))
    end
  end

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:info, "Du har logget ut. Sees senere")
    |> redirect(to: Routes.session_path(conn, :new))
  end
end
