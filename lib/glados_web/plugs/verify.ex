defmodule GladosWeb.Plugs.Verify do
  import Plug.Conn
  import Phoenix.Controller

  alias Glados.Accounts
  alias GladosWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  # If there is an unverified session, fetch id and check if user is verified
  def call(%{private: %{plug_session: %{"unverified_user" => user_id}}} = conn, _opts) do
    user = Accounts.get_user!(user_id)

    if(not user.verified) do
      conn
    else
      conn
      |> put_flash(:error, "Din bruker er allerede verifisert.")
      |> redirect(to: "/")
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
