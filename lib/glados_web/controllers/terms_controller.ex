defmodule GladosWeb.TermsController do
  use GladosWeb, :controller
  plug(:put_layout, {GladosWeb.LayoutView, "terms_layout.html"})
  def terms_and_conditions(conn, _params),  do: render(conn, "terms_and_conditions.html")
end
