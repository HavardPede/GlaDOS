defmodule GladosWeb.Live.View.CrewApplication do
  @moduledoc """
  The liveview session handler for the application page.
  """

  use Phoenix.LiveView
  alias Glados.{CrewApplications, EventCrew}


  def render(assigns) do
    Phoenix.View.render(GladosWeb.MemberView, "crew_application.html", assigns)
  end

  def mount(%{user_id: user_id, event_id: event_id, application: application}, socket) do
    page_order = CrewApplications.get_page_order()
    page = hd(page_order)
    pages = CrewApplications.get_pages()
    categorized_pages = categorize_pages(application, page_order)

    socket =
      socket
      |> assign(:page, page)
      |> assign(:pages, pages)
      |> assign(:categorized_pages, categorized_pages)
      |> assign(:page_order, page_order)
      |> assign(:questions, pages[page])
      |> assign(:answers, application)
      |> assign(:crew, EventCrew.get_crew_list())
      |> assign(:selected_crew, %{})
      |> assign(:event_id, event_id)
      |> assign(:user_id, user_id)

    {:ok, socket}
  end

  def handle_event(
        "set_answer",
        %{"_target" => [target]} = values,
        %{
          assigns: %{
            answers: old_answers,
            page: page,
            page_order: page_order
          }
        } = socket
      ) do
    question_number =
      target
      |> Integer.parse()
      |> elem(0)

    new_answers =
      old_answers
      |> put_in([page, question_number], values[target])

    categorized_pages = categorize_pages(new_answers, page_order)

    socket =
      socket
      |> assign(:answers, new_answers)
      |> assign(:categorized_pages, categorized_pages)

    {:noreply, socket}
  end

  def handle_event(
        "next_page",
        _values,
        %{assigns: %{page: page, page_order: page_order, pages: pages}} = socket
      ) do
    {:ok, next_page} = change_page(page, page_order, :next)

    new_socket =
      socket
      |> assign(page: next_page)
      |> assign(questions: pages[next_page])

    {:noreply, new_socket}
  end

  def handle_event(
        "previous_page",
        _values,
        %{assigns: %{page: page, page_order: page_order, pages: pages}} = socket
      ) do
    {:ok, next_page} = change_page(page, page_order, :previous)

    new_socket =
      socket
      |> assign(page: next_page)
      |> assign(questions: pages[next_page])

    {:noreply, new_socket}
  end

  def handle_event(
        "send_application",
        _values,
        %{
          assigns: %{
            user_id: user_id,
            event_id: event_id,
            answers: answers
          }
        } = socket
      ) do
    EventCrew.send_application(user_id, event_id, answers)
    {:noreply, socket}
  end

  # ---------- Private functions ---------- #

  # Given a page_map and a page_order, return a map of type %{page: category}.
  # Category is either :complete, :invalid or :incomplete
  def categorize_pages(%{} = answers, page_order) do
    page_order
    |> Enum.reverse()
    |> Enum.reduce({%{}, false}, fn page, {categorized_pages, fail_incomplete?} ->
      categorized_page =
        answers[page]
        |> categorize_page(fail_incomplete?)

      {Map.put(categorized_pages, page, categorized_page),
       fail_incomplete? || categorized_page == :complete}
    end)
    |> elem(0)
  end

  defp categorize_page(%{} = page_answers, fail_incomplete?) do
    case {completed_page?(page_answers), fail_incomplete?} do
      {true, _} -> :complete
      {_, true} -> :invalid
      _ -> :incomplete
    end
  end

  defp completed_page?(%{} = page_answers) do
    page_answers
    |> Map.values()
    |> Enum.all?(&(&1 != ""))
  end

  defp change_page(page, page_order, movement_indicator) do
    current_index =
      page_order
      |> Enum.find_index(&(page == &1))

    page_order
    |> Enum.at(current_index + movement(movement_indicator))
    |> OK.required()
  end

  def movement(:next), do: +1
  def movement(:previous), do: -1
end
