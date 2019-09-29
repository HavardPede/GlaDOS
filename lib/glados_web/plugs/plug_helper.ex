defmodule GladosWeb.Plugs.PlugHelper do
  import Plug.Conn
  import Phoenix.Controller

  alias GladosWeb.Router.Helpers, as: Routes
  alias Glados.Accounts

  def redirect(conn) do
    user_id = get_session(conn, :current_user_id)
    current_user = Accounts.get_user!(user_id)

    case current_user.auth_level do
      # Member
      1 ->
        conn
        |> redirect(to: Routes.user_path(conn, :index))

      # Logger
      2 ->
        conn
        |> redirect(to: Routes.logger_path(conn, :logger_transactions))
        |> halt()

      # Crew
      3 ->
        conn
        |> put_status(:not_found)
        |> put_view(GladosWeb.ErrorView)
        |> render("404.html")

      # Chief
      4 ->
        conn
        |> put_status(:not_found)
        |> put_view(GladosWeb.ErrorView)
        |> render("404.html")

      # Admin
      5 ->
        conn
        |> redirect(to: Routes.logger_path(conn, :logger_crew))
        |> halt()
    end
  end
end
