defmodule Glados.Repo.Migrations.AddShopTransactionsTable do
  use Ecto.Migration

  def up do
    create table(:shop_transactions) do
      add(:user_id, references(:users, type: :uuid, on_delete: :delete_all), primary_key: true)

      add(:product_id, references(:products, type: :bigint, on_delete: :delete_all),
        primary_key: true
      )

      add(:event_id, references(:event, type: :integer, on_delete: :delete_all), primary_key: true)

      timestamps()
    end

    create(index(:shop_transactions, [:user_id]))
    create(index(:shop_transactions, [:event_id]))
  end

  def down do
    drop table(:shop_transactions)
  end
end
