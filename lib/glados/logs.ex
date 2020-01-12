defmodule Glados.Logs do
  @moduledoc """
  The Logger and transactions context.
  """

  import Ecto.Query, warn: false
  alias Glados.Repo

  alias Glados.Logger.CrewTransactions
  alias Glados.Logger.LoggerCrew

  @doc """
  Returns the list of logger crew members.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_logger_crew do
    Repo.all(LoggerCrew)
  end

  @doc """
  Creates a logger crew member.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_logger_crew(attrs \\ %{}) do
    new_user = %LoggerCrew{}

    LoggerCrew.changeset(new_user, attrs)
    |> Repo.insert()
  end

  def get_logger_crew!(id), do: Repo.get!(LoggerCrew, id)

  def logger_crew_exists?(id), do: Repo.exists?(from crew in LoggerCrew, where: crew.id == ^id)

  def delete_logger_crew(crew) do
    Repo.delete(crew)
  end

  def create_logger_transaction(attrs \\ %{}) do
    new_user = %CrewTransactions{}

    CrewTransactions.changeset(new_user, attrs)
    |> Repo.insert()
  end

  def get_all_crew_transactions, do: Repo.all(CrewTransactions)

  def get_crew_transaction!(id), do: Repo.get!(CrewTransactions, id)

  def delete_transaction(transaction) do
    Repo.delete(transaction)
  end
end
