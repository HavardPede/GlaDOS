defmodule Glados.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def up do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :username, :string, null: false
      add :encrypted_password, :string, null: false
      add :dob, :date, null: false
      add :email, :string, null: false
      add :address, :string, null: false
      add :postcode, :integer, null: false
      add :phone_number, :string, null: false
      add :auth_level, :integer, default: 1, null: false
      add :verified, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:username])
  end

  def down do
    drop table(:users)
  end
end
