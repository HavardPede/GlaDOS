defmodule GladosWeb.Plugs.Auth do
  import Plug.Conn
  import Phoenix.Controller
  alias Glados.Accounts.Auth
  alias GladosWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
    IO.inspect(Auth.signed_in?(conn), lablel: "signed in")
    if Auth.signed_in?(conn) do
      conn
    else
      conn
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt()
    end
  end
end
