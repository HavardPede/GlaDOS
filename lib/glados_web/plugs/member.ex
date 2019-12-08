defmodule GladosWeb.Plugs.Member do
  alias Glados.Accounts
  alias GladosWeb.Plugs.PlugHelper

  def init(opts), do: opts

  @member_auth_levels [1, 3, 4]

  def call(conn, _opts) do
    current_user = PlugHelper.get_current_user(conn)

    if(is_a_member?(current_user)) do
      conn
    else
      conn
      |> PlugHelper.redirect()
    end
  end

  defp is_a_member?(%{auth_level: member_type}), do: member_type in @member_auth_levels
end
