defmodule Glados.Repo.Migrations.AddEventCrewTable do
  use Ecto.Migration

  def up do
    create table(:event_crew, primary_key: false) do
      add(:role, :string, null: false)
      add(:application, :map, null: false)

      add(:user_id, references(:users, [type: :binary_id, on_delete: :delete_all]), primary_key: true)
      add(:event_id, references(:event, [type: :integer, on_delete: :delete_all]), primary_key: true)

      timestamps()
    end

    create(index(:event_crew, [:event_id]))
    create(index(:event_crew, [:user_id]))

    create(
      unique_index(:event_crew, [:user_id, :event_id], name: :user_id_event_id_unique_index)
    )
  end

  def down do
    drop table(:event_crew)
  end
end
