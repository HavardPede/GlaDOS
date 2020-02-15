defmodule Glados.Events.Product do
  @moduledoc """
  Schema declaration for a cafeteria product.
  """
 use Ecto.Schema

  import Ecto.Changeset
  alias Glados.Events.Event

  schema "products" do
    field(:name, :string, null: false)
    field(:barcode, :string, null: false)
    field(:price, :float, null: false)
    belongs_to(:event, Event)

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :barcode, :price, :event_id])
    |> validate_required([:name, :barcode, :price, :event_id],
      message: "Du må fylle inn dette feltet."
    )
    |> unique_constraint(:barcode, message: "Strekkoden finnes allerede")
  end

end
