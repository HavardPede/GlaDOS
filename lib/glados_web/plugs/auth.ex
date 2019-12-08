defmodule GladosWeb.Plugs.Auth do
  @moduledoc """
  Plug to redirect to login page, if user is guest (not logged in).
  """

  import Plug.Conn
  import Phoenix.Controller
  alias Glados.Accounts.Auth
  alias GladosWeb.Plugs.PlugHelper
  alias GladosWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
    if Auth.signed_in?(conn) do
      conn
    else
      PlugHelper.redirect(conn)
    end
  end
end
