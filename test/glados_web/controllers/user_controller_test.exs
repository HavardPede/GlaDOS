defmodule GladosWeb.UserControllerTest do
  use GladosWeb.ConnCase

  alias Glados.{Accounts, Repo}

  @user1_id Ecto.UUID.generate()

  @create_attrs %{
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
    auth_level: 1,
    verified: false,
    password: "testPassword123",
    password_confirmation: "testPassword123"
  }

  @invalid_attrs %{email: nil, name: nil, username: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  describe "create user - " do
    test "Adds user to database when using valid data", %{conn: conn} do
      initial_user_count = 
      Repo.all(Glados.Accounts.User)
      |> Enum.count
      
      post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      
      user_count = 
      Repo.all(Glados.Accounts.User)
      |> Enum.count

      assert initial_user_count == user_count - 1
    end

    test "Does not add user to databaes when using invalid data", %{conn: conn} do
      conn = build_conn()
      
      post(conn, Routes.user_path(conn, :create), user: %{@create_attrs | name: "invalid_name"})
      post(conn, Routes.user_path(conn, :create), user: %{@create_attrs | name: "invalid username", username: "inv"})
      post(conn, Routes.user_path(conn, :create), user: %{@create_attrs | name: "invalid postcode", postcode: 0})
      post(conn, Routes.user_path(conn, :create), user: %{@create_attrs | name: "invalid phone", phone_number: "123"})
      post(conn, Routes.user_path(conn, :create), user: %{@create_attrs | name: "invalid day", day: "32"})
      post(conn, Routes.user_path(conn, :create), user: %{@create_attrs | name: "invalid month", month: "13"})
      post(conn, Routes.user_path(conn, :create), user: %{@create_attrs | name: "invalid year", year: "100"})
      post(conn, Routes.user_path(conn, :create), user: %{@create_attrs | name: "invalid email", email: "invalid"})
      post(conn, Routes.user_path(conn, :create), user: %{@create_attrs | name: "invalid confirmation password", password_confirmation: "invalid"})
      post(conn, Routes.user_path(conn, :create), user: %{@create_attrs | name: "invalid password", password: "123", password_confirmation: "123"})
      
      new_users = 
      Repo.all(Glados.Accounts.User)
      |> Enum.map(&(&1.name))
      
      assert length(new_users) == 0
    end

    test "renders email verification page when valid user is added" do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert html_response(conn, 302)
      assert redirected_to(conn) == Routes.user_path(conn, :send_email_verification)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Lag en ny bruker for å søke crew!"
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
