defmodule GladosWeb.MemberControllerTest do
  use GladosWeb.ConnCase

  alias Helpers.AccountHelper
  alias Helpers.EventHelper
  alias Glados.Events.Event

  describe "plug" do
    setup [:create_user, :login_user, :create_event]

    test "loads the selected events data to the connection", %{conn: conn, event_id: event_id} do
      conn =
        conn
        |> get(Routes.member_path(conn, :event_landing, event_id))

      assert %Event{id: event_id} = conn.assigns.event
    end
  end

  defp create_user(params), do: AccountHelper.create_user(params)
  defp login_user(params), do: AccountHelper.login_user(params)
  defp create_event(_params), do: EventHelper.create_event()
end
