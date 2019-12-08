defmodule Glados.Events.Event do
  use Ecto.Schema

  import Ecto.Changeset

  alias Glados.Accounts.User
  alias Glados.Events.EventCrew
  alias Glados.Events


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
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:id, :name, :start, :end, :address, :active])
    |> validate_required(
      [:id, :name, :start, :end, :address, :active],
      message: "Du må fylle inn dette feltet."
    )
    |> validate_dates()
    |> validate_active()
  end

  defp validate_dates(%{changes: %{start: start_date, end: end_date}} = changeset) do
   validate_dates_helper(start_date, end_date, changeset)
  end
  defp validate_dates(%{changes: %{end: end_date}} = changeset) do
    validate_dates_helper(changeset.data.start, end_date, changeset)
  end
  defp validate_dates(%{changes: %{start: start_date}} = changeset) do
    validate_dates_helper(start_date, changeset.data.end, changeset)
  end
  defp validate_dates(changeset), do: changeset

  defp validate_dates_helper(start_date, end_date, changeset) do
    if Timex.compare(start_date, end_date) < 0 do
      changeset
    else
      add_error(
        changeset,
        :end,
        "Slutt dato må være etter start dato."
        )
    end
  end

  defp validate_active(%{changes: %{active: active}} = changeset) do
    if active do
      event = Events.get_active_event()
      if event.id == changeset.data.id do
        changeset
      else
        add_error(
          changeset,
          :active,
          "Det finnes allerede et aktivt event."
        )
      end
    end
  end
  defp validate_active(changeset), do: changeset
end
