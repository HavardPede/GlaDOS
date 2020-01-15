defmodule GladosWeb.LiveView.CrewApplication do
  @moduledoc """
  The liveview session handler for the application page.
  """

  use Phoenix.LiveView
  alias Glados.CrewApplications

  @crew ["katine", "security", "info", "scene", "compo", "rydde"]

  def render(assigns) do
    Phoenix.View.render(GladosWeb.MemberView, "crew_application.html", assigns)
  end

  def mount(%{}, socket) do
    socket =
      socket
      |> assign(:page, 1)
      |> assign(:max_pages, CrewApplications.page_count())
      |> assign(:questions, CrewApplications.get_questions())
      |> assign(:answers, CrewApplications.create_answers_map())
      |> assign(:crew, @crew)

    {:ok, socket}
  end

  def handle_event("prev_page", _value, socket) do
    {:noreply, assign(socket, :page, socket.assigns.page - 1)}
  end

  def handle_event("next_page", _value, socket) do
    {:noreply, assign(socket, :page, socket.assigns.page + 1)}
  end

  def handle_event("set_answer", %{"_target" => [target]} = values, socket) do
    answers =
      socket.assigns.answers
      |> Map.put(String.to_atom(target), values[target])

    {:noreply, assign(socket, :answers, answers)}
  end
end
