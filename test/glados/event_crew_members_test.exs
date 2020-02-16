defmodule Glados.EventCrewTest do
  @moduledoc false
  use Glados.DataCase
  alias Glados.EventCrew
  alias Helpers.{AccountHelper, EventHelper}

  describe "send_application/3" do
    setup [:create_event, :create_user]

    test "creates an application when given valid data", %{user: user, event: event} do
      EventCrew.send_application(user.id, event.id, %{})

      assert 1 == EventCrew.get_all_event_crew_members() |> length()
    end
  end

  defp create_event(_), do: EventHelper.create_event()
  defp create_user(_), do: AccountHelper.create_user(:user)
end
