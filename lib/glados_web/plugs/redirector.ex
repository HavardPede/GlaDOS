defmodule GladosWeb.Plugs.Redirector do







































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

    case current_user.auth_level do
      1 ->
        conn
        |> redirect(to: Routes.user_path(conn, :index))
        |> halt()

      2 ->
        conn
        |> redirect(to: Routes.logger_path(conn, :index))
        |> halt()

      3 ->
        conn

      4 ->
        conn

      5 ->
        conn
        |> redirect(to: Routes.logger_path(conn, :logger_crew))
        |> halt()
    end
  end
end
