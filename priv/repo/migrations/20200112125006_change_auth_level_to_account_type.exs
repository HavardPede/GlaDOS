defmodule Glados.Repo.Migrations.ChangeAuthLevelToAccountType do
  use Ecto.Migration

  def up do
    alter table(:users) do
      remove :auth_level
      add :account_type, :text, default: "member", null: false
    end
  end

  def down do
    alter table(:users) do
      remove :account_type
      add :auth_level, :integer, default: 1, null: false
    end
  end
end
