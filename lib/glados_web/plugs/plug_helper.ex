defmodule GladosWeb.Plugs.PlugHelper do
  import Plug.Conn
  import Phoenix.Controller

  alias GladosWeb.Router.Helpers, as: Routes
  alias Glados.Accounts

  def redirect(conn) do
    user_id = get_session(conn, :current_user_id)
    current_user = Accounts.get_user!(user_id)

    user_id
    |> Accounts.get_user!()
    |> Map.get(:auth_level)
    |> redir(conn)
  end

  # Member
  defp redir(1, conn) do
    conn
    |> redirect(to: Routes.member_path(conn, :index))
  end

  # Logger
  defp redir(2, conn) do
    conn
    |> redirect(to: Routes.logger_path(conn, :logger_transactions))
    |> halt()
  end

  # Admin
  defp redir(5, conn) do
    conn
    |> redirect(to: Routes.admin_path(conn, :index))
    |> halt()
  end

  # Default
  defp redir(_, conn) do
    conn
    |> put_status(:not_found)
    |> put_view(GladosWeb.ErrorView)
    |> render("404.html")
  end

  def get_current_user(conn) do
    conn
    |> Plug.Conn.get_session(:current_user_id)
    |> Accounts.get_user!()
  end
end
