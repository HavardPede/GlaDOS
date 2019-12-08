defmodule GladosWeb.AccountControllerTest do
  use GladosWeb.ConnCase

  alias Glados.{Accounts, Repo, Token}

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
    auth_level: 1,
    verified: true,
    password: "testPassword123",
    password_confirmation: "testPassword123"
  }

  @unverified_user_attrs %{
    @valid_user_attrs
    | verified: false
  }

  @invalid_user_attrs %{email: nil, name: nil, username: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@valid_user_attrs)
    user
  end

  def fixture(:unverified_user) do
    {:ok, user} = Accounts.create_user(@unverified_user_attrs)
    user
  end

  describe "create user - " do
    test "Adds user to database when using valid data", %{conn: conn} do
      initial_user_count =
        Repo.all(Glados.Accounts.User)
        |> Enum.count()

      post(conn, Routes.account_path(conn, :create), user: @valid_user_attrs)

      user_count =
        Repo.all(Glados.Accounts.User)
        |> Enum.count()

      assert initial_user_count == user_count - 1
    end

    test "Does not add user to databaes when using invalid data", %{conn: conn} do
      post(conn, Routes.account_path(conn, :create),
        user: %{@valid_user_attrs | name: "invalid_name"}
      )

      post(conn, Routes.account_path(conn, :create),
        user: %{@valid_user_attrs | name: "invalid username", username: "inv"}
      )

      post(conn, Routes.account_path(conn, :create),
        user: %{@valid_user_attrs | name: "invalid postcode", postcode: 0}
      )

      post(conn, Routes.account_path(conn, :create),
        user: %{@valid_user_attrs | name: "invalid phone", phone_number: "123"}
      )

      post(conn, Routes.account_path(conn, :create),
        user: %{@valid_user_attrs | name: "invalid day", day: "32"}
      )

      post(conn, Routes.account_path(conn, :create),
        user: %{@valid_user_attrs | name: "invalid month", month: "13"}
      )

      post(conn, Routes.account_path(conn, :create),
        user: %{@valid_user_attrs | name: "invalid year", year: "100"}
      )

      post(conn, Routes.account_path(conn, :create),
        user: %{@valid_user_attrs | name: "invalid email", email: "invalid"}
      )

      post(conn, Routes.account_path(conn, :create),
        user: %{
          @valid_user_attrs
          | name: "invalid confirmation password",
            password_confirmation: "invalid"
        }
      )

      post(conn, Routes.account_path(conn, :create),
        user: %{
          @valid_user_attrs
          | name: "invalid password",
            password: "123",
            password_confirmation: "123"
        }
      )

      new_users =
        Repo.all(Glados.Accounts.User)
        |> Enum.map(& &1.name)

      assert Enum.empty?(new_users)
    end

    test "renders email verification page when valid user is added", %{conn: conn} do
      conn = post(conn, Routes.account_path(conn, :create), user: @valid_user_attrs)
      assert html_response(conn, 302)

      assert redirected_to(conn) == Routes.account_path(conn, :send_email_verification)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.account_path(conn, :create), user: @invalid_user_attrs)
      assert html_response(conn, 200) =~ "Lag en ny bruker for å søke crew!"
    end
  end

  describe "User login -" do
    setup [:create_user]

    test "Using valid authentication logs the user in", %{conn: conn, user: _user} do
      conn =
        post(conn, Routes.session_path(conn, :create),
          session: %{username: @valid_user_attrs.username, password: @valid_user_attrs.password}
        )

      assert redirected_to(conn) == Routes.member_path(conn, :index)
    end

    test "Using invalid authentication does not log the user in", %{conn: conn, user: _user} do
      conn =
        post(conn, Routes.session_path(conn, :create),
          session: %{username: @valid_user_attrs.username, password: "Invalid password"}
        )

      redirected_path = redirected_to(conn, 302)
      conn = get(recycle(conn), redirected_path)
      assert html_response(conn, 200) =~ "Velkommen til"
    end

    test "Using hashed password as authentication does not log the user in", %{
      conn: conn,
      user: user
    } do
      conn =
        post(conn, Routes.session_path(conn, :create),
          session: %{username: user.username, password: user.encrypted_password}
        )

      redirected_path = redirected_to(conn, 302)
      conn = get(recycle(conn), redirected_path)
      assert html_response(conn, 200) =~ "Velkommen til"
    end
  end

  describe "Account verification" do
    setup [:create_unverified_user]

    test "Logging in to an unverfied user shows a link to verify", %{conn: conn, user: _user} do
      conn =
        post(conn, Routes.session_path(conn, :create),
          session: %{
            username: @unverified_user_attrs.username,
            password: @unverified_user_attrs.password
          }
        )

      assert html_response(conn, 200) =~ "Velkommen til"
      assert html_response(conn, 200) =~ "Du er ikke verifisert!"
    end

    test "Verifying user works", %{conn: conn, user: user} do
      token = Token.generate_new_account_token(user)

      conn = get(conn, Routes.account_path(conn, :verify_email, token: token))

      redirected_path = redirected_to(conn, 302)
      conn = get(recycle(conn), redirected_path)
      assert html_response(conn, 200) =~ "Din bruker er nå verifisert!"

      conn =
        post(conn, Routes.session_path(conn, :create),
          session: %{
            username: @unverified_user_attrs.username,
            password: @unverified_user_attrs.password
          }
        )

      assert html_response(conn, 302)
    end

    test "Using verification url multiple times shows that user is already verified", %{
      conn: conn,
      user: user
    } do
      token = Token.generate_new_account_token(user)

      conn = get(conn, Routes.account_path(conn, :verify_email, token: token))

      redirected_path = redirected_to(conn, 302)
      conn = get(recycle(conn), redirected_path)
      assert html_response(conn, 200) =~ "Din bruker er nå verifisert!"

      conn = get(conn, Routes.account_path(conn, :verify_email, token: token))

      redirected_path = redirected_to(conn, 302)
      conn = get(recycle(conn), redirected_path)
      assert html_response(conn, 200) =~ "Din bruker er allerede verifisert."
    end

    test "Does not allow user to view /verifiser without valid token", %{conn: conn} do
      conn = get(conn, Routes.account_path(conn, :verify_email))

      assert html_response(conn, 404)

      conn = get(conn, Routes.account_path(conn, :verify_email, token: "invalid_token"))

      redirected_path = redirected_to(conn, 302)
      conn = get(recycle(conn), redirected_path)
      assert html_response(conn, 200) =~ "Verifikasjons-lenken er ugyldig."
    end

    test "Does not allow the user to view /verifikasjonsendt without an unverified user in session",
         %{conn: conn} do
      conn = get(conn, Routes.account_path(conn, :send_email_verification))
      assert html_response(conn, 404)
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end

  defp create_unverified_user(_) do
    user = fixture(:unverified_user)
    {:ok, user: user}
  end
end
