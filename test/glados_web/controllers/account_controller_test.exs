defmodule GladosWeb.AccountControllerTest do
  use GladosWeb.ConnCase

  alias Glados.{Repo, Token}
  alias Helpers.AccountHelper

  @encryption Application.get_env(:glados, :password_encryption)
  @extra_valid_password "SomeExtraPassw0rd"
  @valid_name "Tommy Shelby"
  @invalid_name "invalid"
  @invalid_email "invalid"
  @invalid_phone "123"
  @invalid_address ""
  @invalid_postcode "ab"
  @invalid_day "60"
  @invalid_month "60"
  @invalid_year "60"

  @not_valid_info_flash "Bruker info ble ikke oppdatert."
  @valid_info_flash "Bruker info ble oppdatert."

  describe "create user - " do
    test "Adds user to database when using valid data", %{conn: conn} do
      initial_user_count =
        Repo.all(Glados.Accounts.User)
        |> Enum.count()

      post(conn, Routes.account_path(conn, :create),
        user: AccountHelper.get_valid_user_attributes()
      )

      user_count =
        Repo.all(Glados.Accounts.User)
        |> Enum.count()

      assert initial_user_count == user_count - 1
    end

    test "Does not add user to databaes when using invalid data", %{conn: conn} do
      post(conn, Routes.account_path(conn, :create),
        user: %{AccountHelper.get_valid_user_attributes() | name: "invalid_name"}
      )

      post(conn, Routes.account_path(conn, :create),
        user: %{
          AccountHelper.get_valid_user_attributes()
          | name: "invalid username",
            username: "inv"
        }
      )

      post(conn, Routes.account_path(conn, :create),
        user: %{AccountHelper.get_valid_user_attributes() | name: "invalid postcode", postcode: 0}
      )

      post(conn, Routes.account_path(conn, :create),
        user: %{
          AccountHelper.get_valid_user_attributes()
          | name: "invalid phone",
            phone_number: "123"
        }
      )

      post(conn, Routes.account_path(conn, :create),
        user: %{AccountHelper.get_valid_user_attributes() | name: "invalid day", day: "32"}
      )

      post(conn, Routes.account_path(conn, :create),
        user: %{AccountHelper.get_valid_user_attributes() | name: "invalid month", month: "13"}
      )

      post(conn, Routes.account_path(conn, :create),
        user: %{AccountHelper.get_valid_user_attributes() | name: "invalid year", year: "100"}
      )

      post(conn, Routes.account_path(conn, :create),
        user: %{
          AccountHelper.get_valid_user_attributes()
          | name: "invalid email",
            email: "invalid"
        }
      )

      post(conn, Routes.account_path(conn, :create),
        user: %{
          AccountHelper.get_valid_user_attributes()
          | name: "invalid confirmation password",
            password_confirmation: "invalid"
        }
      )

      post(conn, Routes.account_path(conn, :create),
        user: %{
          AccountHelper.get_valid_user_attributes()
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
      conn =
        post(conn, Routes.account_path(conn, :create),
          user: AccountHelper.get_valid_user_attributes()
        )

      assert html_response(conn, 302)

      assert redirected_to(conn) == Routes.account_path(conn, :send_email_verification)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.account_path(conn, :create),
          user: AccountHelper.get_invalid_user_attributes()
        )

      assert html_response(conn, 200) =~ "Lag en ny bruker for å søke crew!"
    end
  end

  describe "User login -" do
    setup [:create_user]

    test "Using valid authentication logs the user in", %{conn: conn, user: _user} do
      conn =
        post(conn, Routes.session_path(conn, :create),
          session: %{
            username: AccountHelper.get_valid_user_attributes().username,
            password: AccountHelper.get_valid_user_attributes().password
          }
        )

      assert Routes.member_path(conn, :index) == redirected_to(conn)
    end

    test "Using invalid authentication does not log the user in", %{conn: conn, user: _user} do
      conn =
        post(conn, Routes.session_path(conn, :create),
          session: %{
            username: AccountHelper.get_valid_user_attributes().username,
            password: "Invalid password"
          }
        )

      redirected_path = redirected_to(conn, 302)
      conn = get(recycle(conn), redirected_path)
      assert html_response(conn, 200) =~ "Velkommen til"
    end
  end

  describe "Account verification -" do
    setup [:create_unverified_user]

    test "Logging in to an unverfied user shows a link to verify", %{conn: conn, user: _user} do
      conn =
        post(conn, Routes.session_path(conn, :create),
          session: %{
            username: AccountHelper.get_unverified_user_attributes().username,
            password: AccountHelper.get_unverified_user_attributes().password
          }
        )

      assert html_response(conn, 200) =~ "Velkommen til"
      assert html_response(conn, 200) =~ "Du er ikke verifisert!"
    end

    test "Verifying user works", %{conn: conn, user: user} do
      token = Token.generate_new_account_token(user)

      conn =
        conn
        |> Plug.Test.init_test_session(unverified_user: user.id)
        |> get(Routes.account_path(conn, :verify_email, token: token))

      redirected_path = redirected_to(conn, 302)
      conn = get(recycle(conn), redirected_path)
      assert html_response(conn, 200) =~ "Din bruker er nå verifisert!"

      conn =
        post(conn, Routes.session_path(conn, :create),
          session: %{
            username: AccountHelper.get_unverified_user_attributes().username,
            password: AccountHelper.get_unverified_user_attributes().password
          }
        )

      assert html_response(conn, 302)
    end

    test "Using verification url multiple times shows that user is already verified", %{
      conn: conn,
      user: user
    } do
      token = Token.generate_new_account_token(user)

      conn =
        conn
        |> Plug.Test.init_test_session(unverified_user: user.id)
        |> get(Routes.account_path(conn, :verify_email, token: token))

      redirected_path = redirected_to(conn, 302)
      conn = get(recycle(conn), redirected_path)
      assert html_response(conn, 200) =~ "Din bruker er nå verifisert!"

      conn =
        conn
        |> get(Routes.account_path(conn, :verify_email, token: token))

      redirected_path = redirected_to(conn, 302)
      conn = get(recycle(conn), redirected_path)
      assert html_response(conn, 200) =~ "Din bruker er allerede verifisert."
    end

    test "Verification url with valid token but missing session data throws 404", %{
      conn: conn,
      user: user
    } do
      token = Token.generate_new_account_token(user)
      conn = get(conn, Routes.account_path(conn, :verify_email, token: token))
      assert html_response(conn, 404)
    end

    test "Does not allow user to view /verifiser without valid token", %{conn: conn} do
      conn = get(conn, Routes.account_path(conn, :verify_email))

      assert html_response(conn, 404)

      conn = get(conn, Routes.account_path(conn, :verify_email, token: "invalid_token"))
      assert html_response(conn, 404)
    end

    test "Does not allow the user to view /verifikasjonsendt without an unverified user in session",
         %{conn: conn} do
      conn = get(conn, Routes.account_path(conn, :send_email_verification))
      assert html_response(conn, 404)
    end
  end

  describe "Edit account info -" do
    setup [:create_user, :login_user]

    test "when logged in, user can access edit page", %{conn: conn} do
      conn = get(conn, Routes.account_path(conn, :edit))
      assert html_response(conn, 200) =~ "Bruker Info"
    end

    test "allowed to edit with valid data", %{conn: conn} do
      conn =
        conn
        |> put(Routes.account_path(conn, :update_user),
          user: %{name: @valid_name}
        )

      redirected_path = redirected_to(conn, 302)
      conn = get(recycle(conn), redirected_path)

      assert html_response(conn, 200) =~ @valid_info_flash
    end

    test "user cant update username", %{conn: conn, user: %{id: user_id}} do
      peaky_username = "PeakyBlinder123"

      put(conn, Routes.account_path(conn, :update_user),
        user: %{name: @valid_name, username: peaky_username}
      )

      user = Glados.Accounts.get_user!(user_id)
      refute user.username == peaky_username
    end

    test "Name must be valid", %{conn: conn} do
      conn = put(conn, Routes.account_path(conn, :update_user), user: %{name: @invalid_name})

      assert html_response(conn, 200) =~ @not_valid_info_flash
    end

    test "Email must be valid", %{conn: conn} do
      conn =
        put(conn, Routes.account_path(conn, :update_user),
          user: %{name: @valid_name, email: @invalid_email}
        )

      assert html_response(conn, 200) =~ @not_valid_info_flash
    end

    test "Phone number must be valid", %{conn: conn} do
      conn =
        put(conn, Routes.account_path(conn, :update_user),
          user: %{name: @valid_name, phone_number: @invalid_phone}
        )

      assert html_response(conn, 200) =~ @not_valid_info_flash
    end

    test "Address must be valid", %{conn: conn} do
      conn =
        put(conn, Routes.account_path(conn, :update_user),
          user: %{name: @valid_name, address: @invalid_address}
        )

      assert html_response(conn, 200) =~ @not_valid_info_flash
    end

    test "Postcode must be valid", %{conn: conn} do
      conn =
        put(conn, Routes.account_path(conn, :update_user),
          user: %{name: @valid_name, postcode: @invalid_postcode}
        )

      assert html_response(conn, 200) =~ @not_valid_info_flash
    end

    test "Dob must be valid", %{conn: conn} do
      conn =
        put(conn, Routes.account_path(conn, :update_user),
          user: %{
            name: @valid_name,
            day: @invalid_day,
            month: @invalid_month,
            year: @invalid_year
          }
        )

      assert html_response(conn, 200) =~ @not_valid_info_flash
    end
  end

  describe "Edit account password -" do
    setup [:create_user, :login_user]

    test "is allowed with valid parameters", %{conn: conn, user: %{id: user_id}} do
      conn =
        conn
        |> put(Routes.account_path(conn, :update_user),
          user: %{
            old_password: AccountHelper.get_valid_user_attributes().password,
            password: @extra_valid_password,
            password_confirmation: @extra_valid_password
          }
        )

      redirected_path = redirected_to(conn, 302)
      conn = get(recycle(conn), redirected_path)

      assert html_response(conn, 200) =~ "Passordet ble oppdatert."

      user_id
      |> Glados.Accounts.get_user!()
      |> @encryption.valid_password?(@extra_valid_password)
      |> assert
    end

    test "not allowed with wrong old_password", %{conn: conn, user: %{id: user_id}} do
      conn =
        conn
        |> put(Routes.account_path(conn, :update_user),
          user: %{
            old_password: "wrong password",
            password: @extra_valid_password,
            password_confirmation: @extra_valid_password
          }
        )

      refute html_response(conn, 200) =~ "Passordet ble oppdatert."

      user_id
      |> Glados.Accounts.get_user!()
      |> @encryption.valid_password?(@extra_valid_password)
      |> refute
    end

    test "not allowed with mismatching confirmation password", %{conn: conn} do
      conn =
        conn
        |> put(Routes.account_path(conn, :update_user),
          user: %{
            old_password: AccountHelper.get_valid_user_attributes().password,
            password: @extra_valid_password,
            password_confirmation: "mismatching Passw0rd"
          }
        )

      refute html_response(conn, 200) =~ "Passordet ble oppdatert."
    end

    test "not allowed when password is too short", %{conn: conn} do
      conn =
        conn
        |> put(Routes.account_path(conn, :update_user),
          user: %{
            old_password: AccountHelper.get_valid_user_attributes().password,
            password: "shortPw",
            password_confirmation: "shortPw"
          }
        )

      refute html_response(conn, 200) =~ "Passordet ble oppdatert."
    end
  end

  defp create_user(params), do: AccountHelper.create_user(params)
  defp create_unverified_user(params), do: AccountHelper.create_unverified_user(params)
  defp login_user(params), do: AccountHelper.login_user(params)
end
