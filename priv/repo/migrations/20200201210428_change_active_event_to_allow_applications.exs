defmodule Glados.Repo.Migrations.ChangeActiveEventToAllowApplications do
  use Ecto.Migration
  def up do
    alter table(:event) do
      add(:allow_applications, :boolean)
      remove(:active)
    end
  end

  def down do
    alter table(:event) do
      remove(:allow_applications)
      add(:active, :boolean, null: false)
    end
  end
end
