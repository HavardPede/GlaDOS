defmodule Glados.Products do
  @moduledoc """
  Defines handlers for cafeteria products.
  """

  import Ecto.Query, only: [from: 2]
  alias Glados.Events.Product
  alias Glados.Repo

  @doc """
  Greates a changeset for the given product.
  """
  def change_product(product \\ %Product{}, changes \\ %{}), do: Product.changeset(product, changes)

  @doc """
  returns a list of all products.

  ## example

    iex > get_products(event_id)
    [%Product{}, %Product{}]

    iex > get_products()
    []
  """
  def get_products(event_id) do
    from(product in Product,
    where: product.event_id == ^event_id)
    |> Repo.all()
  end

  @doc """
  Returns a product in a result tuple
 
  ## example

    iex > get_product(id)
    {:ok, %Product{}}

    iex > get_products(:not_id)
    {:error, struct}
  """
  def get_product(product_id) do
    Repo.get(Product, product_id)
    |> OK.required()
  end

    @doc """
  Creates a new product, and returns a tuple defining the result

  ## Example

    iex > create_product(:invalid)
    {:error, %Prooduct{}}
   
    iex > create_Prooduct(:valid)
    {:ok, %product{}}
  """
  def create_product(%{} = attrs) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end
end
