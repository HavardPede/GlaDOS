defmodule GladosWeb.Plugs.Auth do
  import Plug.Conn
  import Phoenix.Controller

  alias Glados.Accounts
  alias GladosWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
    if user_id = Plug.Conn.get_session(conn, :current_user_id) do
      current_user = Accounts.get_user!(user_id)

      if(current_user.auth_level != 2) do
        conn
      else
        conn
        |> redirect(to: Routes.user_path(conn, :index))
        |> halt()
      end
    else
      conn
      |> redirect(to: Routes.logger_path(conn, :purchases))
      |> halt()
    end
  end
end
