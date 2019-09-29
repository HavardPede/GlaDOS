defmodule GladosWeb.Plugs.Admin do
  alias Glados.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user =
      conn
      |> Plug.Conn.get_session(:current_user_id)
      |> Accounts.get_user!()

    if(current_user.auth_level > 4) do
      conn
    else
      conn
      |> GladosWeb.Plugs.PlugHelper.redirect()
    end
  end
end
