defmodule Glados.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Glados.Repo

  alias Glados.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a single user by email.
  Raises `Ecto.NoResultsError` if the User does not exist.
  """
  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
    |> Glados.Utils.nillable()
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{auth_level: 1, verified: false, id: Ecto.UUID.generate()}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user_info(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user_info(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_info(%User{} = user, attrs) do
    user
    |> User.user_info_changeset(attrs)
    |> Repo.update()
  end

  def validate_user(%User{} = user) do
    user
    |> User.verified_changeset(%{verified: true})
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def change_user_info(%User{} = user) do
    User.user_info_changeset(user, %{})
  end

  @doc """
  Returns a changeset for setting the new password on an account
  """
  def change_password(%User{} = user) do
    User.password_changeset(user, %{})
  end

  @doc """
  Set change password
  """
  def update_password(%User{} = user, attrs) do
    user
    |> User.password_changeset(attrs)
    |> Repo.update()
  end
end
