defmodule GladosWeb.Plugs.LoggerAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias Glados.Accounts
  alias GladosWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user =
      conn
      |> Plug.Conn.get_session(:current_user_id)
      |> Accounts.get_user!()

    if(current_user.auth_level == 2) do
      conn
    else
      conn
      |> redirect(to: Routes.user_path(conn, :index))
      |> halt()
    end
  end
end
