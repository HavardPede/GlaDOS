defmodule Glados.AccountsTest do
  use Glados.DataCase

  alias Glados.Accounts
  alias Glados.Accounts.User

  @user1_id Ecto.UUID.generate()

  @valid_attrs %{
    id: @user1_id,
    name: "Test Name",
    username: "TestUsername",
    postcode: "1234",
    phone_number: "123 45 678",
    day: "01",
    month: "01",
    year: "2001",
    email: "test@email.com",
    address: "Test address",
    account_type: "member",
    verified: false,
    password: "testPassword123",
    password_confirmation: "testPassword123"
  }

  @update_attrs %{
    email: "some@valid.email",
    name: "some updated name",
    username: "updated"
  }
  @invalid_attrs %{email: nil, name: nil, username: nil}

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Accounts.create_user()

    user
  end

  defp remove_virtual_fields(user) do
    %{user | day: nil, month: nil, year: nil, password: nil, password_confirmation: nil}
  end

  test "list_users/0 returns all users" do
    user =
      user_fixture()
      |> remove_virtual_fields()

    assert Accounts.list_users() == [user]
  end

  test "get_user!/1 returns the user with given id" do
    user =
      user_fixture()
      |> remove_virtual_fields()

    assert Accounts.get_user!(user.id) == user
  end

  test "create_user/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
  end

  test "update_user/2 with valid data updates the user" do
    user = user_fixture()
    assert {:ok, %User{} = user} = Accounts.update_user_info(user, @update_attrs)
    assert user.name == "some updated name"
    assert user.email == "some@valid.email"
  end

  test "update_user/2 with invalid data returns error changeset" do
    user =
      user_fixture()
      |> remove_virtual_fields()

    assert {:error, %Ecto.Changeset{}} = Accounts.update_user_info(user, @invalid_attrs)
    assert user == Accounts.get_user!(user.id)
  end

  test "delete_user/1 deletes the user" do
    user = user_fixture()
    assert {:ok, %User{}} = Accounts.delete_user(user)
    assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
  end

  test "change_user/1 returns a user changeset" do
    user = user_fixture()
    assert %Ecto.Changeset{} = Accounts.change_user(user)
  end
end
