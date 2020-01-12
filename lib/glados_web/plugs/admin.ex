defmodule GladosWeb.Plugs.Admin do
  @moduledoc """
  Plug that redirects user if they are not admin.
  """

  alias GladosWeb.Plugs.PlugHelper

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user = PlugHelper.get_current_user(conn)

    if is_admin?(current_user) do
      conn
    else
      conn
      |> PlugHelper.redirect()
    end
  end

  defp is_admin?(user) do
    user.account_type == "admin"
  end
end
