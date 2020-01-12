defmodule Glados.Logger.LoggerCrew do
  @moduledoc """
  Module to represent each crew member that should be logged,
  and some trivial data about these crew members.
  This was an early implementation and will be removed as crew members
  start creating accounts on the application.
  """

  # TODO remove this schema once crew members actually start using Glados.

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
