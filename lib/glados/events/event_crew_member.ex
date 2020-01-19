defmodule Glados.Events.EventCrewMember do
  @moduledoc """
  Schema representing the many to many relationship between a user and a event.
  This will contain a users application for an event and the role the user held, 
  as well as a reference to both the user and the event entities (duh).
  """

  use Ecto.Schema

  alias Glados.Accounts.User
  alias Glados.Events.Event

  @primary_key false
  schema "event_crew" do
    field(:role, :string)
    field(:application, :map)

    belongs_to(:user, User, primary_key: true)
    belongs_to(:event, Event, primary_key: true)
    timestamps()
  end
end
