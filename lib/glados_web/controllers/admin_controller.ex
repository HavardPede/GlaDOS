defmodule GladosWeb.AdminController do
  @moduledoc """
  The controller for the admin control panel.
  """
  use GladosWeb, :controller

  require Logger
  alias Glados.{CrewApplications, Events, EventCrew, Products}
  alias GladosWeb.Plugs.PlugHelper
  alias GladosWeb.Endpoint

  @empty_sub_pages []
  @sub_page_not_selected ""

  plug :put_layout, "admin_layout.html"

  ##
  ## INDEX PAGE
  ##
  def index(conn, _params) do
    assigns = %{
      events: Events.get_events(),
      nav_data: construct_nav_data("Events", @empty_sub_pages, @sub_page_not_selected)
    }

    render(conn, "events.html", assigns)
  end

  ##
  ## NEW EVENT
  ##
  def new_event(conn, _params) do
    assigns = %{
      changeset: Events.change_event(),
      nav_data: construct_nav_data("Events", @empty_sub_pages, @sub_page_not_selected)
    }

    render(conn, "new_event.html", assigns)
  end

  ##
  ## CREATE EVENT
  ##
  def create_event(conn, %{"event" => event}) do
    case Events.create_event(event) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Ditt nye event er laget.")
        |> redirect(to: Routes.admin_path(GladosWeb.Endpoint, :edit_event, event.id))
        |> halt()

      {:error, changeset} ->
        assigns = %{
          changeset: changeset,
          nav_data: construct_nav_data("Events", @empty_sub_pages, @sub_page_not_selected)
        }

        render(conn, "new_event.html", assigns)
    end
  end

  def create_event(conn, _), do: PlugHelper.throw_404(conn)

  ##
  ## EDIT EVENT PAGE
  ##
  def edit_event(conn, %{"event_id" => event_id}) do
    assigns = %{
      changeset: Events.change_event(conn.assigns.event),
      nav_data: construct_nav_data("Events", get_event_sub_pages(event_id), "Event info")
    }

    render(conn, "edit_event.html", assigns)
  end

  ##
  ## UPDATE EVENT
  ##
  def update_event(%{assigns: %{event: event}} = conn, %{"event" => event_params} = params) do
    event
    |> Events.update_event(event_params)
    |> case do
      {:ok, event} ->
        conn
        |> Plug.Conn.assign(:event, event)
        |> put_flash(:info, "Eventet har blitt oppdatert.")
        |> edit_event(params)

      {:error, changeset} ->
        assigns = %{
          changeset: changeset,
          nav_data: construct_nav_data("Events", get_event_sub_pages(event.id), "Event info")
        }

        render(conn, "edit_event.html", assigns)
    end
  end

  def update_event(conn, _params), do: PlugHelper.throw_404(conn)

  ##
  ## VIEW APPLICATIONS PAGE
  ##
  def view_applications(conn, %{"event_id" => event_id}) do
    {:ok, applicants} = EventCrew.get_applicants(event_id)

    assigns = %{
      applicants: applicants,
      nav_data: construct_nav_data("Events", get_event_sub_pages(event_id), "Søknader"),
      event_id: event_id
    }

    render(conn, "applicants.html", assigns)
  end

  ##
  ## TOGGLE APPLICATIONS
  ##
  def toggle_applications(%{assigns: %{event: event}} = conn, params) do
    Events.toggle_applications(event)
    |> case do
      {:ok, event} -> Plug.Conn.assign(conn, :event, event)
      _ -> conn
    end
    |> view_applications(params)
  end

  ##
  ## REVIEW APPLICATION
  ##

  def review_application(conn, %{"event_id" => event_id, "applicant_id" => applicant_id}) do
    {:ok, applicant} = EventCrew.get_event_crew_member(applicant_id, event_id)

    assigns = %{
      applicant: applicant,
      nav_data: construct_nav_data("Events", get_event_sub_pages(event_id), "Søknader"),
      crew_list: EventCrew.get_crew_list(),
      questions: CrewApplications.get_pages()
    }

    render(conn, "view_application.html", assigns)
  end

  ##
  ## HANDLE APPLICATION
  ##
  def handle_application(conn, %{
        "event_id" => event_id,
        "applicant_id" => user_id,
        "crew" => %{"crew" => value}
      }) do
    user_id
    |> EventCrew.get_event_crew_member(event_id)
    ~>> EventCrew.set_role()
    ~>> EventCrew.set_crew(value)
    |> case do
      {:ok, _updated_applicant} -> put_flash(conn, :info, "Rollen har blitt satt.")
      {:error, _reason} -> put_flash(conn, :error, "En feil oppstod.")
    end
    |> redirect(to: Routes.admin_path(GladosWeb.Endpoint, :review_application, event_id, user_id))
  end

  ##
  ## VIEW CREW
  ##
  def view_crew(conn, %{"event_id" => event_id}) do
    {:ok, crew} = EventCrew.get_crew(event_id)

    assigns = %{
      crew: crew,
      nav_data: construct_nav_data("Events", get_event_sub_pages(event_id), "Crew")
    }

    render(conn, "crew.html", assigns)
  end

  ##
  ## SET CREW ID
  ##
  def set_crew_id(conn, %{"event_id" => event_id, "user_id" => user_id, "id_card" => id_card}) do
    EventCrew.get_event_crew_member(user_id, event_id)
    ~>> EventCrew.update(id_card: id_card)

    {:ok, crew} = EventCrew.get_crew(event_id)

    assigns = %{
      crew: crew,
      nav_data: construct_nav_data("Events", get_event_sub_pages(event_id), "Crew")
    }

    render(conn, "crew.html", assigns)
  end

  ##
  ## CAFETERIA
  ##
  def cafeteria(conn, %{"event_id" => event_id}) do
    assigns = %{
      products: Products.get_products(event_id),
      changeset: Products.change_product(),
      nav_data: construct_nav_data("Events", get_event_sub_pages(event_id), "Kantine")
    }

    render(conn, "cafeteria.html", assigns)
  end

  ##
  ## HANDLE CAFETERIA EVENT
  ##
  ## create product
  ##
  def handle_cafeteria_event(conn, %{"product" => product, "event_id" => event_id} = params) do
    product
    |> Map.put("event_id", event_id)
    |> Products.create_product()
    |> case do
      {:ok, _product} -> put_flash(conn, :info, "Produktet ble lagt til.")
      {:error, _changeset} -> put_flash(conn, :error, "Produktet ble ikke lagt til.")
    end
    |> cafeteria(params)
  end

  ##
  ## HANDLE CAFETERIA EVENT
  ##
  ## toggle_shop
  ##
  def handle_cafeteria_event(%{assigns: %{event: event}} = conn, params) do
    Events.toggle_shop(event)
    |> case do
      {:ok, event} -> Plug.Conn.assign(conn, :event, event)
      _ -> conn
    end
    |> cafeteria(params)
  end

  ##
  ## DELETE PRODUCT
  ##
  def delete_product(conn, %{"product_id" => product_id, "event_id" => event_id}) do
    Products.get_product(product_id)
    ~>> Products.delete_product()
    |> case do
      {:ok, _} -> put_flash(conn, :info, "Produktet ble fjernet.")
      {:error, _} -> put_flash(conn, :error, "Produktet ble ikke fjernet.")
    end
    |> redirect(to: Routes.admin_path(GladosWeb.Endpoint, :cafeteria, event_id))
    |> halt()
  end

  ## ------ Private Functions ------ ##

  def construct_nav_data(current_page, sub_pages \\ %{}, current_sub_page \\ [])

  def construct_nav_data(current_page, sub_pages, current_sub_page) do
    if current_page in Map.keys(get_nav_elements()) and is_map(sub_pages) do
      %{
        pages: get_nav_elements(),
        current_page: current_page,
        sub_pages: sub_pages,
        current_sub_page: current_sub_page
      }
    else
      Logger.warn("construct_nav_data was given invalid parameters.")
      %{pages: get_nav_elements(), current_page: nil, sub_pages: %{}, current_sub_page: nil}
    end
  end

  def get_event_sub_pages(event_id),
    do: %{
      "Event info" => Routes.admin_path(Endpoint, :edit_event, event_id),
      "Kantine" => Routes.admin_path(Endpoint, :cafeteria, event_id),
      "Søknader" => Routes.admin_path(Endpoint, :view_applications, event_id),
      "Crew" => Routes.admin_path(Endpoint, :view_crew, event_id)
    }

  def get_nav_elements,
    do: %{
      "Events" => Routes.admin_path(Endpoint, :index),
      "ESLG" => "#"
    }
end
