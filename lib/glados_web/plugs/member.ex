defmodule GladosWeb.Plugs.Member do
  alias Glados.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user =
      conn
      |> Plug.Conn.get_session(:current_user_id)
      |> Accounts.get_user!()

    if(current_user.auth_level == 2) do
      conn
      |> GladosWeb.Plugs.PlugHelper.redirect()
    else
      conn
    end
  end
end
