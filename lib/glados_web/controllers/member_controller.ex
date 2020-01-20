defmodule GladosWeb.MemberController do
  use GladosWeb, :controller

  import Phoenix.LiveView.Controller
  alias GladosWeb.LiveView

  alias Glados.Events

  def index(conn, _params) do
    events = Events.get_events()
    current_event = Events.get_current_event()

    render(conn, "index.html", events: events, current_event: current_event)
  end

  def event_landing(conn, %{"event_id" => event_id}) do
    session = %{user_id: conn.assigns.user.id, event_id: event_id}
    live_render(conn, LiveView.CrewApplication, session: session)
  end
end
