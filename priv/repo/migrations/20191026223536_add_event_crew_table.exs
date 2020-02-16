defmodule Glados.Repo.Migrations.AddEventCrewTable do
  use Ecto.Migration

  def up do
    create table(:event_crew_members, primary_key: false) do
      add(:role, :string, null: false)
      add(:application, :map, null: false)

      add(:user_id, references(:users, type: :uuid, on_delete: :delete_all), primary_key: true)

      add(:event_id, references(:event, type: :integer, on_delete: :delete_all), primary_key: true)

      timestamps()
    end

    create(index(:event_crew_members, [:event_id]))
    create(index(:event_crew_members, [:user_id]))

    create(
      unique_index(:event_crew_members, [:user_id, :event_id],
        name: :user_id_event_id_unique_index
      )
    )
  end

  def down do
    drop table(:event_crew_members)
  end
end
