defmodule Glados.Repo.Migrations.RenameAndAlterEventCrewTable do
  use Ecto.Migration

  def up do
    alter table(:event_crew_members) do
      add(:id_card, :string)
    end
  end

  def down do
    alter table(:event_crew_members) do
      remove(:id_card, :string)
    end
  end
end
