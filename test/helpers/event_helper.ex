defmodule Helpers.EventHelper do
  @moduledoc """
  Defines a set of helper functions for events handling
  """

  alias Glados.Events

  @valid_inputs %{
    id: 1,
    name: "Lanmine test",
    start: ~U[2120-01-11 21:21:21.210510Z],
    end: ~U[2120-01-11 22:22:22.210510Z],
    address: "Fobarville"
  }

  @valid_inputs_2 %{
    id: 2,
    name: "Lanmine test 2",
    start: ~U[2019-01-11 23:22:22.210510Z],
    end: ~U[2019-01-11 23:23:22.210510Z],
    address: "BarFooVille"
  }

  @doc """
  Creates an event and adds it to the db.
  """
  def create_event do
    {:ok, event} =
      @valid_inputs
      |> Events.create_event()

    {:ok, event_id: @valid_inputs.id, event: event}
  end

  @doc """
  Creates an event with id 2.
  """
  def create_second_event do
    {:ok, event} =
      @valid_inputs_2
      |> Events.create_event()

    {:ok, event_id2: @valid_inputs.id, event2: event}
  end

  @doc """
  Returns attributes for the event, as a map
  """
  def get_event_data, do: @valid_inputs
end
