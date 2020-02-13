defmodule Glados.Products.Product do
  @moduledoc """
  Schema declaration for a cafeteria product.
  """
 use Ecto.Schema

  import Ecto.Changeset
  alias Glados.Accounts.User
  alias Glados.Events

  schema "products" do
    field(:name, :string, null: false)
    field(:barcode, :string, null: false)
    belongs_to(:event, Event)

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :barcode, :event_id])
    |> validate_required(
      [:name, :barcode, :event_id],
      message: "Du må fylle inn dette feltet."
    )
    |> unique_constraint(:barcode, message: "Strekkoden finnes allerede")
  end

end
