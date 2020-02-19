defmodule GladosWeb.Plugs.DismissCookies do
  @moduledoc """
  Plug that fetches the :dismiss_cookies session value and puts it in assigns for the template.
  """

  import Plug.Conn

  def init(opts), do: opts
  def call(conn, _opts) do
    conn
    |> assign(:dismiss_cookies, get_session(conn, :dismiss_cookies))
  end

end
