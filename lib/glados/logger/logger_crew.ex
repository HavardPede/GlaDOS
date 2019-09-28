defmodule Glados.Logger.LoggerCrew do
  use Ecto.Schema
  import Ecto.Changeset
  alias Glados.Logger.CrewTransactions

  @primary_key {:id, :string, auto_generate: false}
  schema "logger_crew" do
    field(:name, :string, null: false)
    field(:last_name, :string, null: false)
    field(:crew, :string, null: false)

    has_many(:crew_transactions, CrewTransactions)
    timestamps()
  end

  def changeset(crew, attrs) do
    crew
    |> cast(attrs, [
      :id,
      :name,
      :last_name,
      :crew
    ])
    |> validate_required([
      :id,
      :name,
      :last_name,
      :crew
    ])
  end
end
