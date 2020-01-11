defmodule GladosWeb.Plugs.LoadEvents do
  @moduledoc """
  Fetches all events and assigns the whole list to the connection assignment, as well as the current/next event
  as its own assignemnt.
  """
  import Plug.Conn
  alias Glados.Events

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> assign(:events, Events.get_events())
    |> assign(:current, Events.get_current_event())
  end
end
