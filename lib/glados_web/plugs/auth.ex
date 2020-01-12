defmodule GladosWeb.Plugs.Auth do
  @moduledoc """
  Plug to redirect to login page, if user is guest (not logged in).
  """

  import Plug.Conn
  alias Glados.Accounts.Auth
  alias GladosWeb.Plugs.PlugHelper

  def init(opts), do: opts

  def call(conn, _opts) do
    if Auth.signed_in?(conn) do
      user = PlugHelper.get_current_user(conn)
      assign(conn, :user, user)
    else
      PlugHelper.redirect(conn)
    end
  end
end
