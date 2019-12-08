defmodule GladosWeb.Plugs.Guest do
  @moduledoc """
  Plug that redirects the user to a authenticated page, if they are logged in (not guest).
  """

  import Plug.Conn
  import Phoenix.Controller
  alias GladosWeb.Plugs.PlugHelper
  alias GladosWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
    if Plug.Conn.get_session(conn, :current_user_id) do
      PlugHelper.redirect(conn)
    else
      conn
    end
  end
end
