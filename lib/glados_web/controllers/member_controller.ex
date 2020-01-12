defmodule GladosWeb.MemberController do
  use GladosWeb, :controller

  alias Glados.Events

  def index(conn, _params) do
    events = Events.get_events()
    current_event = Events.get_current_event()

    render(conn, "index.html", events: events, current_event: current_event)
  end

  def event_landing(conn, _params) do
    render(conn, "event_landing_page.html")
  end
end
