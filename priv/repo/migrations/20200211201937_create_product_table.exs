defmodule Glados.Repo.Migrations.CreateProductTable do
  use Ecto.Migration

  def up do
    create table(:products) do
      add :name, :string, null: false
      add :barcode, :string, null: false
      add :price, :float, null: false
      add :event_id, references("event", type: :integer, on_delete: :nilify_all)
      timestamps()
    end
    create unique_index(:products, [:barcode, :event_id], name: :unique_barcode_per_event)
  end

  def down do
    drop table(:products)
  end
end
