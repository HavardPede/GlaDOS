defmodule Glados.Repo.Migrations.AddShopToEvent do
  use Ecto.Migration

 def up do
    alter table(:event) do
      add(:shop, :boolean)
    end
  end

  def down do
    alter table(:event) do
      remove(:shop)
    end
  end
end
