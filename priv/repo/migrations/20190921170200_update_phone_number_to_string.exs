defmodule Glados.Repo.Migrations.UpdatePhoneNumberToString do
  use Ecto.Migration

  def up do
    alter table(:users) do
      modify :phone_number, :string
    end
  end

  def down do
    alter table(:users) do
      modify :phone_number, :integer
    end
  end
end
