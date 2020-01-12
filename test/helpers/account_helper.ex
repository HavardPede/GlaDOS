defmodule Helpers.AccountHelper do
  @moduledoc """
  Defines a set of helper functions for account handling
  """

  import Plug.Test
  alias Glados.Accounts

  @user1_id Ecto.UUID.generate()

  @valid_user_attrs %{
    id: @user1_id,
    name: "Test Name",
    username: "TestUsername",
    postcode: 1234,
    phone_number: "123 45 678",
    day: "01",
    month: "01",
    year: "2001",
    email: "test@email.com",
    address: "Test address",
    account_type: "member",
    verified: true,
    password: "testPassword123",
    password_confirmation: "testPassword123"
  }
  @unverified_user_attrs %{
    @valid_user_attrs
    | verified: false
  }
  @invalid_user_attrs %{email: nil, name: nil, username: nil}

  def get_valid_user_attributes, do: @valid_user_attrs
  def get_invalid_user_attributes, do: @invalid_user_attrs
  def get_unverified_user_attributes, do: @unverified_user_attrs

  def create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end

  def create_admin_user(_) do
    user = fixture(:admin)
    {:ok, user: user}
  end

  def create_unverified_user(_) do
    user = fixture(:unverified_user)
    {:ok, user: user}
  end

  defp fixture(:user) do
    {:ok, user} = Accounts.create_user(@valid_user_attrs)
    user
  end

  defp fixture(:unverified_user) do
    {:ok, user} = Accounts.create_user(@unverified_user_attrs)
    user
  end

  defp fixture(:admin) do
    {:ok, user} = Accounts.create_user(%{@unverified_user_attrs | account_type: "admin"})
    user
  end

  def login_user(%{conn: conn, user: user}) do
    conn =
      conn
      |> init_test_session(%{
        current_user_id: user.id,
        account_type: user.account_type
      })

    {:ok, conn: conn}
  end
end
