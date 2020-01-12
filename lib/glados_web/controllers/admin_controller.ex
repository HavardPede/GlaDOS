defmodule GladosWeb.AdminController do
  use GladosWeb, :controller

  alias Glados.Events
  alias Glados.Events.{Event}
  alias GladosWeb.Plugs.PlugHelper

  @doc """
    Displays index admin page.
  """
  def index(conn, _params) do
    events = Events.get_events()
    render(conn, "index.html", events: events)
  end

  @doc """
    Displays the list of events.
  """
  def events(conn, _params) do
    events = Glados.Events.get_events()
    render(conn, "events.html", events: events)
  end

  def new_event(conn, _params) do
    active_event = Events.get_active_event!()

    changeset = Events.change_event(%Event{})
    render(conn, "new_event.html", changeset: changeset, active_event: active_event)
  end

  def create_event(conn, %{"event" => event}) do
    case Events.create_event(event) do
      {:ok, _} ->
        conn
        |> redirect(to: Routes.admin_path(GladosWeb.Endpoint, :events))
        |> halt()

      {:error, changeset} ->
        active_event = Events.get_active_event!()

        render(conn, "new_event.html", changeset: changeset, active_event: active_event)
    end
  end

  def create_event(conn, _), do: PlugHelper.render_404(conn)

  def edit_event(conn, %{"event_id" => event_id}) do
    with {:ok, event} <- Events.get_event(event_id),
         active_event <- Events.get_active_event!() do
      changeset = Events.change_event(event)
      render(conn, "update_event.html", changeset: changeset, active_event: active_event)
    else
      {:error, :nil_value} ->
        conn
        |> put_flash(:error, "Oops, vi klarte ikke å finne dette eventet.")
        |> redirect(to: Routes.admin_path(GladosWeb.Endpoint, :events))
        |> halt()
    end
  end

  def update_event(conn, %{"event" => event_params, "event_id" => event_id}) do
    with {:ok, event} <- Events.get_event(event_id),
         {:ok, _updated_event} <- Events.update_event(event, event_params) do
      conn
      |> put_flash(:info, "Eventet har blitt oppdatert.")
      |> redirect(to: Routes.admin_path(GladosWeb.Endpoint, :events))
      |> halt()
    else
      {:error, :nil_value} ->
        conn
        |> put_flash(:error, "En feil oppstod. Eventet har ikke blitt oppdatert.")
        |> redirect(to: Routes.admin_path(GladosWeb.Endpoint, :events))
        |> halt()

      {:error, changeset} ->
        active_event = Events.get_active_event!()
        render(conn, "update_event.html", changeset: changeset, active_event: active_event)
    end
  end

  def update_event(conn, _params), do: PlugHelper.render_404(conn)
end
