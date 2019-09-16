defmodule Glados.Repo.Migrations.UpdateUsersWithAuthLevel do
  use Ecto.Migration

  def up do
    alter table(:users) do
      add :auth_level, :integer, default: 1, required: true
    end
  end

  def down do
    alter table(:users) do
      remove :auth_level
    end
  end
end
