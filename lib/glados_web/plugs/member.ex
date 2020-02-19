defmodule GladosWeb.Plugs.Member do
  @moduledoc """
  Plug that halts non-member accounts. Elevated member accounts (ie crew) still count as member.
  """

  alias GladosWeb.Plugs.PlugHelper

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user = PlugHelper.get_current_user(conn)

    if is_a_member?(current_user) do
      conn
    else
      conn
      |> PlugHelper.redirect()
    end
  end

  defp is_a_member?(%{account_type: account_type}), do: account_type == "member"
end
