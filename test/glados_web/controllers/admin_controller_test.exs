defmodule GladosWeb.AdminControllerTest do
  use GladosWeb.ConnCase

  alias Helpers.AccountHelper
  alias Helpers.EventHelper

  describe "accessing :index with admin account" do
    setup [:create_admin_user, :login_user, :create_event]

    test "shows the index page", %{conn: conn, event: event} do
      conn =
        conn
        |> get(Routes.admin_path(conn, :index))

      assert html_response(conn, 200) =~ event.name
    end
  end

  describe "accessing :index with a member account" do
    setup [:create_user, :login_user, :create_event]

    test "shows the index page", %{conn: conn, event: event} do
      conn =
        conn
        |> get(Routes.admin_path(conn, :index))

      assert html_response(conn, 302)
      assert Routes.member_path(conn, :index) == redirected_to(conn)
    end
  end

  defp create_admin_user(params), do: AccountHelper.create_admin_user(params)
  defp create_user(params), do: AccountHelper.create_user(params)
  defp login_user(params), do: AccountHelper.login_user(params)
  defp create_event(_params), do: EventHelper.create_event()
end
