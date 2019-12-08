defmodule GladosWeb.Plugs.Verify do
  @moduledoc """
  This plug makes sure there exists an unverified user within the session.
  If there is no unverified user, throw 404.
  """

  import Plug.Conn
  import Phoenix.Controller
  alias Glados.Accounts

  def init(opts), do: opts

  # If there is an unverified session, fetch id and check if user is verified
  def call(%{private: %{plug_session: %{"unverified_user" => user_id}}} = conn, _opts) do
    user = Accounts.get_user!(user_id)

    if user.verified do
      conn
      |> put_flash(:error, "Din bruker er allerede verifisert.")
      |> redirect(to: "/")
    else
      conn
    end
  end

  # If no unverified session, redirect
  def call(conn, _opts) do
    conn
    |> put_status(:not_found)
    |> put_view(GladosWeb.ErrorView)
    |> render("404.html")
    |> halt()
  end
end
