defmodule GladosWeb.Plugs.Auth do
  import Plug.Conn
  import Phoenix.Controller
  alias GladosWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
    if get_session(conn, :current_user_id) do
      conn
    else
      conn
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt()
    end
  end
end
