defmodule GladosWeb.SessionController do
  use GladosWeb, :controller

  @moduledoc """
  Controller for handling actions related to a login session.
  """

  import Phoenix.HTML.Link
  alias Glados.Accounts.Auth

  @doc """
  Route to display login page
  """
  def new(conn, _params) do
    render(conn, "new.html", layout: {GladosWeb.LayoutView, "no_nav.html"})
  end

  @doc """
  Route to generate a new login session
  """
  def create(conn, %{"session" => auth_params}) do
    case Auth.login(auth_params) do
      {:ok, user} ->
        if(user.verified) do
          conn
          |> put_session(:current_user_id, user.id)
          |> redirect(to: Routes.user_path(conn, :index))
        else
          conn
          |> put_session(:unverified_user, user.id)
          |> put_flash(
            :error,
            [
              "Du er ikke verifisert!  ",
              link("Klikk her for å sende en ny email",
                to: Routes.user_path(conn, :send_email_verification),
                class: "dark_blue"
              ),
              "."
            ]
          )
          |> render("new.html", layout: {GladosWeb.LayoutView, "no_nav.html"})
        end

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Et problem oppstod med ditt brukernavn/passord")
        |> render("new.html", layout: {GladosWeb.LayoutView, "no_nav.html"})
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:current_user_id)
    |> put_flash(:info, "Du har logget ut. Sees senere")
    |> redirect(to: Routes.session_path(conn, :new))
  end
end
