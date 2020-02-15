defmodule Glados.Events.ShopTransaction do
  @moduledoc """
  Schema representing the purchases made at the shop for an event.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Glados.Accounts.User
  alias Glados.Events.{Event, Product}

  @primary_key false
  schema "shop_transactions" do
    belongs_to(:user, User, type: :binary_id)
    belongs_to(:event, Event)
    belongs_to(:product, Product)
    timestamps()
  end

  def changeset(event_crew_member, params \\ %{}) do
    event_crew_member
    |> cast(params, [:user_id, :event_id, :product_id])
    |> validate_required([:user_id, :event_id, :product_id])

    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:event_id)
    |> foreign_key_constraint(:product_id)
  end
end
