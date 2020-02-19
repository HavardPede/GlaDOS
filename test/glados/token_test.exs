defmodule Glados.TokenTest do
  use Glados.DataCase

  alias Glados.{Accounts, Token}

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

  def fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Accounts.create_user()

    user
  end

  defp create_unverified_user(_) do
    user = fixture()
    {:ok, user: user}
  end

  describe "valid user verification tokens" do
    setup [:create_unverified_user]

    test "The generated verification token will verify an account", %{user: user} do
      token = Token.generate_new_account_token(user)
      {:ok, user_id} = Token.verify_new_account_token(token)
      assert user_id == user.id
    end
  end
end
