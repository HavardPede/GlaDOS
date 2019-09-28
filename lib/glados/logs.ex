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
  def list_users do
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
  def create_user(attrs \\ %{}) do
    new_user = %LoggerCrew{}

    LoggerCrew.changeset(new_user, attrs)
    |> Repo.insert()
  end
end
