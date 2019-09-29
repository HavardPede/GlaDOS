defmodule GladosWeb.Plugs.Guest do
  import Plug.Conn
  import Phoenix.Controller
  alias GladosWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
    if Plug.Conn.get_session(conn, :current_user_id) do
      conn
      |> redirect(to: Routes.user_path(conn, :index))
      |> halt()
    else
      conn
    end
  end
end
