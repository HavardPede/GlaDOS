defmodule GladosWeb.PageController do
  use GladosWeb, :controller

  def index(conn, _params) do
    render(conn, "login.html")
  end
end
