defmodule Glados.EventsTest do
  @moduledoc """
  Test-module for all functions related to events.
  """
  use Glados.DataCase
  alias Glados.Events
  alias Helpers.EventHelper

  describe "create_event()" do
    setup [:create_event]

    test "with valid data gets stored in db", %{event_id: id} do
      assert event = Glados.Repo.get(Glados.Events.Event, id)
    end

    test "does not work when adding event with existing id" do
      assert_raise(
        Ecto.ConstraintError,
        fn ->
          EventHelper.get_event_data()
          |> Events.create_event()
        end
      )
    end
  end

  describe "change_event()" do
    setup [:create_event, :create_second_event]

    test "works as expected", %{event: event} do
      changeset =
        event
        |> Events.change_event()

      assert %Ecto.Changeset{data: event} = changeset
    end
  end

  describe "get_events()" do
    test "returns empty list when no events exist" do
      assert Enum.empty?(Events.get_events())
    end

    test "returns list of all events" do
      create_event()
      create_second_event()
      assert 2 == length(Events.get_events())
    end
  end

  describe "get_current_event()" do
    test "returns next upcoming event if there is no active event" do
      EventHelper.create_event()
      assert %Events.Event{active: false, start: start_time} = Events.get_current_event()
      assert -1 == Timex.compare(Timex.now(), start_time)
    end

    test "returns previous event if there is no upcoming or active event" do
      EventHelper.create_second_event()
      assert %Events.Event{active: false, start: start_time} = Events.get_current_event()
      assert 1 == Timex.compare(Timex.now(), start_time)
    end
  end

  defp create_event(_ \\ %{}), do: EventHelper.create_event()
  defp create_second_event(_ \\ %{}), do: EventHelper.create_second_event()
end
