defmodule Glados.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def up do
    create table(:users) do
      add :name, :string
      add :username, :string
      add :encrypted_password, :string
      add :dob, :date
      add :email, :string
      add :address, :string
      add :postcode, :integer
      add :phone_number, :integer

      timestamps()
    end
  end

  def down do
    drop table(:users)
  end
end
