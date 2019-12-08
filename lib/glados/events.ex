defmodule Glados.Events do
  
  @moduledoc """
  The context for all functions related to events.
  """
  
  alias Glados.Events.Event
  alias Glados.Repo
  alias Glados.Utils

  @doc """
  Returns a changeset for a specifi event.
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
  def create_event(attrs \\ %{}) do
    Event.changeset(%Event{}, attrs)
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
  def get_events() do
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

  def get_active_event() do
    Repo.get_by(Event, [active: true])
  end
end