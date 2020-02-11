defmodule Glados.Events.EventCrewMember do
  @moduledoc """
  Schema representing the many to many relationship between a user and a event.
  This will contain a users application for an event and the role the user held, 
  as well as a reference to both the user and the event entities (duh).
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Glados.Accounts.User
  alias Glados.Events.Event
  alias Glados.EventCrew

  @already_exists "Finnes allerede"

  @primary_key false
  schema "event_crew_members" do
    field(:role, :string)
    field(:application, :map)
    field(:id_card, :string)
    field(:crew, :string)

    belongs_to(:user, User, primary_key: true, type: :binary_id)
    belongs_to(:event, Event, primary_key: true)
    timestamps()
  end

  def changeset(event_crew_member, params \\ %{}) do
    event_crew_member
    |> cast(params, [:role, :application, :id_card, :user_id, :event_id, :crew])
    |> validate_required([:role, :application, :user_id, :event_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:event_id)
    |> unique_constraint(:user,
      name: :user_id_event_id_unique_index,
      message: @already_exists
    )
    |> validate_inclusion(:role, EventCrew.get_event_roles())
    |> validate_inclusion(:crew, EventCrew.get_crew_list())
  end
end
