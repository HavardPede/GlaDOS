defmodule GladosWeb.ApiController do
  use GladosWeb, :controller
  
 def dismiss_cookies(conn, _body) do
    conn
    |> fetch_session()
    |> put_session(:dismiss_cookies, true)
    |> put_status(200)
    |> json(%{"success" => true, "message" => "Cookies dismissed"})
  end
end
