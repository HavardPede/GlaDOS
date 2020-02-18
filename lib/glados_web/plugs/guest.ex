defmodule GladosWeb.Plugs.Guest do
  @moduledoc """
  Plug that redirects the user to a authenticated page, if they are logged in (not guest).
  """

  import Plug.Conn
  alias GladosWeb.Plugs.PlugHelper

  def init(opts), do: opts

  def call(conn, _opts) do
    if Plug.Conn.get_session(conn, :current_user_id) do
      PlugHelper.redirect(conn)
    else
      conn
      |> assign(:dismiss_cookies, get_session(conn, :dismiss_cookies))
    end
  end
end
