defmodule Glados.Events do
  @moduledoc """
  The context for all functions related to events.
  """

  alias Glados.Events.Event
  alias Glados.Repo
  alias Glados.Utils

  @doc """
  Returns a changeset for a specific event.
  """
  def change_event(%Event{} = event) do
    Event.changeset(event, %{})
  end

  @doc """
  Creates an event, and returns a tuple defining the result

  ## Example

    iex > create_event(:invalid)
    {:error, %Event{}}
    
    iex > create_event(:valid)
    {:ok, %Event{}}
  """
  def create_event(%{} = attrs) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  returns a list of all events.

  ## example

    iex > get_events()
    [%Event{}, %Event{}]

    iex > get_events()
    []
  """
  def get_events do
    Repo.all(Event)
  end

  @doc """
  Fetches an event when given an id. 

  ## example

    iex > get_event(123)
    {:ok, %Event{}}

    iex > get_event(456)
    {:error, :nil_value}
  """
  def get_event(event_id) do
    Repo.get(Event, event_id)
    |> Repo.preload(:crew_member)
    |> Utils.nillable()
  end

  @doc """
  Updates an event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Fetches the activity that is currently active, or returns nil
  """
  def get_active_event do
    Repo.get_by(Event, active: true)
    |> Utils.nillable()
  end

  @doc """
  Fetches the current event. This goes as the following priority.
  1. Currently active
  2. Next event
  3. Previous event
  4. nil
  """
  def get_current_event do
    [get_active_event(), get_next_event(), get_previous_event()]
    |> Enum.find_value(fn
      {:ok, event} -> event
      _ -> false
    end)
  end

  def get_next_event do
    coming_events =
      get_events()
      |> Enum.filter(&(Timex.compare(&1.start, Timex.now()) >= 0))

    if Enum.empty?(coming_events) do
      {:error, nil}
    else
      Enum.min_by(coming_events, & &1.start)
      |> Utils.ok()
    end
  end

  def get_previous_event do
    previous_events =
      get_events()
      |> Enum.filter(&(Timex.compare(&1.end, Timex.now()) < 0))

    if Enum.empty?(previous_events) do
      {:error, nil}
    else
      Enum.max_by(previous_events, & &1.end)
      |> Utils.ok()
    end
  end
end
