defmodule Glados.Repo.Migrations.AddEventsTable do
  use Ecto.Migration

  def up do
    create table(:event, primary_key: false) do
      add :id, :integer, primary_key: true
      add :name, :string, null: false
      add :start, :naive_datetime
      add :end, :naive_datetime
      add :address, :string, null: false
      add :active, :boolean, null: false

      timestamps()
    end

    create unique_index(:event, [:id])
  end

  def down do
    drop table(:event)
  end
end
