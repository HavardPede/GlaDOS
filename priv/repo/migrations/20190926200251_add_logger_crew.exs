defmodule Glados.Repo.Migrations.AddLoggerCrew do
  use Ecto.Migration

  def up do
    create table(:logger_crew, primary_key: false) do
      add :id, :string, primary_key: true
      add :name, :string, null: false
      add :last_name, :string, null: false
      add :crew, :string, null: false

      timestamps()
    end

    create unique_index(:logger_crew, [:id])
  end

  def down do
    drop table(:logger_crew)
  end
end
