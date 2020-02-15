defmodule Glados.Repo.Migrations.RemoveLoggerTables do
  use Ecto.Migration

  def up do
    drop table(:crew_transactions)
    drop table(:logger_crew)
  end

  def down do
    create table(:logger_crew, primary_key: false) do
      add :id, :string, primary_key: true
      add :name, :string, null: false
      add :last_name, :string, null: false
      add :crew, :string, null: false

      timestamps()
    end

    create table(:crew_transactions) do
      add :logger_crew_id, references("logger_crew", type: :string, on_delete: :nilify_all)
      timestamps()
    end
  end
end
