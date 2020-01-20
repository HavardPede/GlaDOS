defmodule Glados.Repo.Migrations.RenameAndAlterEventCrewTable do
  use Ecto.Migration

  def up do
    rename table(:event_crew), to: table(:event_crew_members)

    alter table(:event_crew_members) do
      add(:id_card, :string)
    end
  end

  def down do
    rename table(:event_crew_members), to: table(:event_crew)

    alter table(:event_crew_members) do
      remove(:id_card, :string)
    end
  end
end
