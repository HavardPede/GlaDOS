defmodule Glados.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :username, :string
      add :password_hash, :string
      add :dob, :date
      add :email, :string

      timestamps()
    end

  end
end
