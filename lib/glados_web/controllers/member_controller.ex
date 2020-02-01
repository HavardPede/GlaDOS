defmodule GladosWeb.MemberController do
  use GladosWeb, :controller

  import Phoenix.LiveView.Controller
  alias Glados.{CrewApplications, Events, EventCrewMembers}
  alias GladosWeb.Live

  def index(conn, _params) do
    events = Events.get_events()
    current_event = Events.get_current_event()

    render(conn, "index.html", events: events, current_event: current_event)
  end

  def event_landing(conn, %{"event_id" => event_id}) do
    EventCrewMembers.get_event_crew_member(conn.assigns.user.id, event_id)
    |> case do
      {:ok, %{role: "applicant"}} ->
        render_event_landing(conn, :waiting)

      {:ok, _member} ->
        render("crew_landing_page.html")

      {:error, :does_not_exist} ->
        render_event_landing(conn, :no_application)
    end
  end

  defp render_event_landing(conn, page) do
    event_id = conn.params["event_id"]
    {:ok, event} = Events.get_event(event_id)

    render(conn, "event_landing_page.html",
      event: event,
      page: page
    )
  end

  def crew_application(conn, %{"event_id" => event_id}) do
    application = CrewApplications.create_answers_map(conn.assigns.user.id, event_id)
    session = %{user_id: conn.assigns.user.id, event_id: event_id, application: application}
    live_render(conn, Live.View.CrewApplication, session: session)
  end
end
