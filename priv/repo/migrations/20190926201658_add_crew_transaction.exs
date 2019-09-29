defmodule Glados.Repo.Migrations.AddCrewTransaction do
  use Ecto.Migration

  def up do
    create table(:crew_transactions) do
      add :logger_crew_id, references("logger_crew", type: :string, on_delete: :nilify_all)
      timestamps()
    end
  end

  def down do
    drop table(:crew_transactions)
  end
end
