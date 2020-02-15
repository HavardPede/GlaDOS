defmodule GladosWeb.Plugs.PlugHelper do
  @moduledoc """
  Defines a set of helper functions for plugs.
  """

  import Plug.Conn
  import Phoenix.Controller

  alias GladosWeb.Router.Helpers, as: Routes
  alias GladosWeb.Live.View.LoggerLive
  alias Glados.{Accounts}

  def redirect(conn) do
    conn
    |> get_session(:current_user_id)
    |> OK.required()
    |> case do
      {:ok, user_id} -> redirect_user(conn, user_id)
      {:error, _} -> redirect_guest(conn)
    end
  end

  defp redirect_user(conn, id) do
    id
    |> Accounts.get_user!()
    |> Map.get(:account_type)
    |> redir(conn)
  end

  defp redirect_guest(conn) do
    conn
    |> redirect(to: Routes.session_path(conn, :new))
    |> halt()
  end

  defp redir("member", conn) do
    conn
    |> redirect(to: Routes.member_path(conn, :index))
    |> halt()
  end

  defp redir("logger", conn) do
    conn
    |> redirect(to: Routes.live_path(conn, LoggerLive))
    |> halt()
  end

  defp redir("admin", conn) do
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

  @doc """
  Given a connection, redirect to a 404 page.
  """
  def throw_404(conn) do
    conn
    |> put_status(:not_found)
    |> put_view(GladosWeb.ErrorView)
    |> render("404.html")
    |> halt()
  end
end
