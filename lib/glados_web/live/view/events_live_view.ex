defmodule GladosWeb.Live.View.EventsLiveView do
  @moduledoc """
  The livecomponent for the event control panel pages.
  """

  use Phoenix.LiveView
  import GladosWeb.Router.Helpers
  alias Glados.{Events, EventCrewMembers}
  alias GladosWeb.Live.Component.NavComponent

  def mount(_params, socket) do
    changeset = Events.change_event()

    socket
    |> assign(
      events: Events.get_events(),
      changeset: changeset,
      page: "",
      sub_pages: [],
      current_sub_page: "",
      event: %{}
    )
    |> OK.wrap()
  end

  # edit event page
  def handle_params(%{"event_id" => event_id}, _uri, socket) do
    with {:ok, event} <- Events.get_preloaded_event(event_id),
         changeset <- Events.change_event(event) do
      socket =
        socket
        |> assign(
          sub_pages: ["event info", "søknader", "kantine", "crew"],
          current_sub_page: "event info",
          page: "edit_event.html",
          changeset: changeset,
          event: event
        )

      {:noreply, socket}
    else
      {:error, :missing_event} ->
        socket
        |> put_flash(:error, "Oops, vi klarte ikke å finne dette eventet.")
        |> live_redirect(to: live_path(socket, __MODULE__))
    end
  end

  # new event page
  def handle_params(%{"page" => "new_event"}, _uri, socket) do
    socket =
      socket
      |> assign(sub_pages: ["nytt event"], current_sub_page: "Nytt event")
      |> assign(page: "new_event.html")

    {:noreply, socket}
  end

  # event list page
  def handle_params(_params, _uri, socket) do
    {:noreply, assign(socket, :page, "events.html")}
  end

  def render(
        %{
          page: page,
          events: events,
          sub_pages: sub_pages,
          current_sub_page: current_sub_page
        } = assigns
      ) do
    ~L"""
    <div class="flex flex-row w-full">
      <%= live_component(@socket, NavComponent, id: :nav, page: :events, sub_pages: sub_pages, current_sub_page: current_sub_page) %>
      <div class="h-full w-48"></div>
      <div class="flex flex-col w-5/6 mx-auto mt-12">
        <%= Phoenix.View.render(GladosWeb.AdminView, "#{page}", assigns) %>
      </div>
    </div>
    """
  end

  def handle_event("edit_event", %{"event_id" => event_id}, socket) do
    {:noreply,
     live_redirect(socket,
       to: live_path(socket, __MODULE__, event_id)
     )}
  end

  def handle_event("new_event", _params, socket) do
    {:noreply, live_redirect(socket, to: live_path(socket, __MODULE__, %{page: :new_event}))}
  end

  def handle_info({:change_page, page}, socket) do
    {:noreply, create_subpage_socket(page, socket)}
  end

  defp create_subpage_socket("nytt event", socket) do
    assign(socket, page: "new_event.html")
  end

  defp create_subpage_socket("event info", socket) do
    assign(socket, page: "edit_event.html")
  end

  defp create_subpage_socket("kantine", socket) do
    assign(socket, page: "cafeteria.html")
  end

  defp create_subpage_socket("crew", socket) do
    {:ok, crew} = EventCrewMembers.get_crew(socket.assigns.event.id)
    assign(socket, page: "crew.html", crew: crew)
  end

  defp create_subpage_socket("søknader", socket) do
    {:ok, applicants} = EventCrewMembers.get_applicants(socket.assigns.event.id)

    socket
    |> assign(
      page: "applicants.html",
      applicants: applicants
    )
  end
end
