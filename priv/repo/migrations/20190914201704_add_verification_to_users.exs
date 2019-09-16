defmodule Glados.Repo.Migrations.AddVerificationToUsers do
  use Ecto.Migration

  def up do
    alter table(:users) do
      add :verified, :boolean, default: false, required: true
    end
  end

  def down do
    alter table(:users) do
      remove :verified
    end
  end
end
