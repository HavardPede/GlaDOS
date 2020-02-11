defmodule GladosWeb.Plugs.FetchEvent do
  @moduledoc """
  This plug loads the event specified in the url, to the connection.
  """

  import Plug.Conn
  alias Glados.Events
  alias GladosWeb.Plugs.PlugHelper

  def init(opts), do: opts

  def call(%{params: %{"event_id" => event_id}} = conn, _opts) do
    event_id
    |> Events.get_preloaded_event()
    |> case do
      {:ok, event} ->
        conn
        |> assign(:event, event)

      {:error, _} ->
        PlugHelper.render_404(conn)
    end
  end

  def call(conn, _opts), do: conn
end
