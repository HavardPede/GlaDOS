defmodule GladosWeb.PageController do
  use GladosWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
