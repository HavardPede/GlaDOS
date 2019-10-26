defmodule GladosWeb.AdminController do
    use GladosWeb, :controller

    @doc """
    Displays the list of events.
    """
    def events(conn, _params) do
        render(conn, "events.html")
    end
end