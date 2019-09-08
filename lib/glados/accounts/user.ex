defmodule Glados.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Glados.Accounts.Encryption

  schema "users" do
    field(:name, :string)
    field(:email, :string)
    field(:username, :string)
    field(:encrypted_password, :string)
    field(:dob, :date)
    field(:address, :string)
    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :name,
      :username,
      :encrypted_password,
      :dob,
      :email,
      :address,
      :password,
      :password_confirmation
    ])
    |> validate_required([
      :name,
      :username,
      :dob,
      :email,
      :address
    ])
    |> cast(attrs, [:name, :username, :dob, :email, :address])
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password)
    |> validate_format(:username, ~r/^[a-z0-9][a-z0-9]+[a-z0-9]$/i)
    |> validate_length(:username, min: 5)
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> downcase_username()
    |> encrypt_password()
    |> validate_required(:encrypted_password)
  end

  defp encrypt_password(changeset) do
    password = get_change(changeset, :password)

    if password do
      encrypted_password = Encryption.hash_password(password)
      put_change(changeset, :encrypted_password, encrypted_password)
    else
      changeset
    end
  end

  defp downcase_username(changeset) do
    update_change(changeset, :username, &String.downcase/1)
  end
end
