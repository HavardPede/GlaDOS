defmodule Glados.Repo.Migrations.AddCrewToCrewMember do
  use Ecto.Migration

  def up do
    alter table(:event_crew_members) do
      add(:crew, :string)
    end
  end

  def down do
    alter table(:event_crew_members) do
      remove(:crew)
    end
  end
end
