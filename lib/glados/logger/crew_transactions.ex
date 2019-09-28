defmodule Glados.Logger.CrewTransactions do
  use Ecto.Schema
  import Ecto.Changeset
  import Glados.Logger.LoggerCrew

  @primary_key {:id, :integer, auto_generate: true}
  schema "crew_transactions" do
    field(:crew_id, :string, null: false)

    belongs_to(:logger_crew, LoggerCrew)

    timestamps()
  end

  # Need to implement a changeset
end
