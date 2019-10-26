defmodule Glados.Events.Event do
  use Ecto.Schema

  import Ecto.Changeset

  alias Glados.Accounts.User
  alias Glados.Events.EventCrew


  @primary_key {:id, :integer, auto_generate: false}
  schema "event" do
    field(:name, :string, null: false)
    field(:start, :naive_datetime)
    field(:end, :naive_datetime)
    field(:address, :string, null: false)
    field(:active, :boolean)

    many_to_many(:crew_member, User, join_through: EventCrew, on_replace: :delete)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [])
    |> validate_required(
      [],
      message: "Du må fylle inn dette feltet."
    )
  end

end
