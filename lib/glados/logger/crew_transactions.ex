defmodule Glados.Logger.CrewTransactions do
  use Ecto.Schema
  import Ecto.Changeset
  import Glados.Logger.LoggerCrew

  schema "crew_transactions" do
    field(:logger_crew_id, :string, null: false)
    belongs_to(:logger_crew, LoggerCrew, define_field: false)

    timestamps()
  end

  # Need to implement a changeset
  def changeset(crew, attrs) do
    crew
    |> cast(attrs, [
      :logger_crew_id
    ])
    |> validate_required([
      :logger_crew_id
    ])
  end
end
