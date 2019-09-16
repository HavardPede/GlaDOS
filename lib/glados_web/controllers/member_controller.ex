defmodule GladosWeb.MemberController do
  use GladosWeb, :controller

  alias Glados.Accounts
  alias Glados.Accounts.User

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
