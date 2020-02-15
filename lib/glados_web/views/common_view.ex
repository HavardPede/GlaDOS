defmodule GladosWeb.CommonView do
  use GladosWeb, :view

  import GladosWeb.Router.Helpers
  alias GladosWeb.Endpoint
  alias Glados.Toolbox

  def get_nav_elements(5) do
    %{
      "Kontroll panel" => Routes.admin_path(GladosWeb.Endpoint, :index)
    }
  end

  def get_nav_elements(_), do: %{}

  def get_paths(request_path) when Kernel.is_bitstring(request_path) do
    String.split(request_path, "/")
    |> Enum.filter(&(&1 != ""))
  end

  @doc """
  Constructs the url to the given path.
  example:
    conn: @conn
    path: "user"
    Output: "www.glados.com/user"
  """
  def get_full_url(conn, path) do
    Routes.url(conn) <>
      "/" <>
      (conn.request_path
       |> get_paths()
       |> Toolbox.List.remove_trailing_elements(path)
       |> Enum.join("/"))
  end
end
