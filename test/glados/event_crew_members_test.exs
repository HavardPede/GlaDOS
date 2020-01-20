defmodule Glados.EventCrewMembersTest do
  @moduledoc false
  use Glados.DataCase
  alias Glados.EventCrewMembers
  alias Helpers.{AccountHelper, EventHelper}

  describe "send_application/3" do
    setup [:create_event, :create_user]

    test "creates an application when given valid data", %{user: user, event: event} do
      EventCrewMembers.send_application(user.id, event.id, %{})

      assert 1 == EventCrewMembers.get_all_event_crew_members() |> length()
    end
  end

  defp create_event(_), do: EventHelper.create_event()
  defp create_user(_), do: AccountHelper.create_user(:user)
end
