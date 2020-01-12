defmodule GladosWeb.Plugs.LoggerAuth do
  @moduledoc """
  Plug that redirects all non-logger users.
  """

  alias GladosWeb.Plugs.PlugHelper

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user = PlugHelper.get_current_user(conn)

    if is_logger?(current_user) do
      conn
    else
      conn
      |> PlugHelper.redirect()
    end
  end

  defp is_logger?(user) do
    user.account_type == "logger"
  end
end
