defmodule Glados.Repo.Migrations.ChangePostcodeToText do
  use Ecto.Migration

  def up do
    alter table(:users) do
      modify(:postcode, :string, null: false)
    end
  end

  def down do
    alter table(:users) do
      modify(:postcode, :integer, null: false)
    end
  end
end
