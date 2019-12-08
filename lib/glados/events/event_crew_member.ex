defmodule Glados.Events.EventCrew do
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
