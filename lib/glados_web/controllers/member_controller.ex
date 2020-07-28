defmodule GladosWeb.MemberController do
  use GladosWeb, :controller

  import Phoenix.LiveView.Controller
  alias Glados.{CrewApplications, Events, EventCrew}
  alias GladosWeb.Live

  def index(conn, _params) do
    events = Events.get_events()
    current_event = Events.get_current_event()

    render(conn, "index.html", events: events, current_event: current_event)
  end

  def event_landing(conn, %{"event_id" => event_id}) do
    EventCrew.get_event_crew_member(conn.assigns.user.id, event_id)
    |> case do
      {:ok, %{role: "applicant"}} ->
        render_event_landing(conn, :waiting)

      {:ok, _member} ->
        render(conn, "crew_landing_page.html")

      {:error, :does_not_exist} ->
        render_event_landing(conn, :no_application)
    end
  end

  defp render_event_landing(conn, page) do
    {:ok, event} =
      conn.params["event_id"]
      |> Events.get_event()

    render(conn, "event_landing_page.html",
      event: event,
      page: page
    )
  end

  def crew_application(conn, %{"event_id" => event_id}) do
    user_id = conn.assigns.user.id

    session =
      user_id
      |> EventCrew.get_event_crew_member(event_id)
      |> case do
        {:ok, member} ->
          %{
            application: CrewApplications.create_answers_map(member),
            has_applied: true
          }

        {:error, _} ->
          %{
            application: CrewApplications.create_answers_map(),
            has_applied: false
          }
      end
      |> Map.put(:user_id, user_id)
      |> Map.put(:event_id, event_id)

    live_render(conn, Live.View.CrewApplication, session: session)
  end
end
