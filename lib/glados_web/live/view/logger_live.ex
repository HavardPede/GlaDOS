defmodule GladosWeb.Live.View.LoggerLive do
  @moduledoc """
  The liveview session responsible for the logger live view.
  """
  use Phoenix.LiveView
  #alias Glados.{Events, EventCrew, Products}

  def mount(_params, socket) do
    socket
    |> assign(cart: [])
    |> OK.wrap()
  end

  def render(assigns) do
    Phoenix.View.render(GladosWeb.LoggerView, "index.html", assigns)
  end
end