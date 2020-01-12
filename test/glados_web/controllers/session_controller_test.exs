defmodule GladosWeb.SessionControllerTest do
  use GladosWeb.ConnCase

  alias Helpers.AccountHelper

  describe "delete route" do
    setup [:create_user, :login_user]

    test "logs out user as expected", %{conn: conn} do
      conn =
        conn
        |> get(Routes.session_path(conn, :delete))

      redirected_path = redirected_to(conn, 302)
      conn = get(recycle(conn), redirected_path)

      assert Routes.session_path(conn, :new) == conn.request_path
      assert :current_user not in conn.private.plug_session
    end
  end

  defp create_user(params), do: AccountHelper.create_user(params)
  defp login_user(params), do: AccountHelper.login_user(params)
end
