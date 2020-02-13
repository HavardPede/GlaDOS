defmodule Glados.Repo.Migrations.AddSalesSystemToEvent do
  use Ecto.Migration

 def up do
    alter table(:event) do
      add(:sales_system, :boolean)
    end
  end

  def down do
    alter table(:event) do
      remove(:sales_system)
    end
  end
end
