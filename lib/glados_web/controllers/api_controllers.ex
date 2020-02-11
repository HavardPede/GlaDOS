defmodule GladosWeb.ApiController do
  @moduledoc """
  Defines all api functions
  """

  alias Glados.Events
  use GladosWeb, :controller

  def toggle_applications(%{assigns: %{event: event}} = conn, _params) do
    Events.update_event(event, %{allow_applications: !event.allow_applications})
    |> case do
      {:ok, event} -> json(conn, %{result: :success})
      {:error, _changeset} -> json(conn, %{result: :error})
    end
  end
end