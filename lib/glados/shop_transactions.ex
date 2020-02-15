defmodule Glados.ShopTransactions do
  @moduledoc """
  Defines handlers for shop transactions.
  """
  import Ecto.Query, only: [from: 2]
  alias Glados.Events.{EventCrewMember, ShopTransaction}
  alias Glados.Accounts.User
  alias Glados.Repo

  @doc """
  Greates a changeset for the given transaction.
  """
  def change_transaction(transaction \\ %ShopTransaction{}, changes), do: ShopTransaction.changeset(transaction, changes)

  @doc """
  Creates a new shop transaction, and returns a tuple defining the result

  ## Example

    iex > create_transaction(:invalid)
    {:error, %Prooduct{}}
   
    iex > create_transaction(:valid)
    {:ok, %ShopTransaction{}}
  """
  def create_transaction(%{} = attrs) do
    %ShopTransaction{}
    |> ShopTransaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %ShopTransaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%ShopTransaction{} = transaction) do
    Repo.delete(transaction)
  end

  @doc """
  This is very specific for rendering transactions. It fetches metadata about a transaction. Mainly the name of the
  customer, and what crew they work in.
  The return format:
  [{transaction, customer_name, crew}, ..]
  """
  def get_event_transactions(event_id) do
      from(
        transaction in ShopTransaction,
        where: transaction.event_id == ^event_id,
        join: user in User, on: transaction.user_id  == user.id,
        join: crew_member in EventCrewMember, on: crew_member.event_id == ^event_id and crew_member.user_id == user.id,
        select: {transaction, user.name, crew_member.crew}
      )
    |> Repo.all()
  end

  @doc """
  Saves a list of transactions.
  """
  def save_transactions(transactions) when is_list(transactions) do
    Repo.transaction(fn ->
      Enum.each(transactions, &Repo.insert/1)
    end)
  end
end
