defmodule GladosWeb.Plugs.Admin do
  alias GladosWeb.Plugs.PlugHelper

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user = PlugHelper.get_current_user(conn)

    if(current_user.auth_level > 4) do
      conn
    else
      conn
      |> PlugHelper.redirect()
    end
  end
end
