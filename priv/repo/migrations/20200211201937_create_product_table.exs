defmodule Glados.Repo.Migrations.CreateProductTable do
  use Ecto.Migration

  def up do
    create table(:products) do
      add :name, :string, null: false
      add :barcode, :string, null: false
      add :event_id, references("event", type: :integer, on_delete: :nilify_all)
      timestamps()
    end
  end

  def down do
    drop table(:products)
  end
end
