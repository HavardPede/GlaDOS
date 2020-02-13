defmodule GladosWeb.AdminControllerTest do
  use GladosWeb.ConnCase

  alias Helpers.AccountHelper
  alias Helpers.EventHelper
  alias Glados.Events

  describe "accessing :index with admin account" do
    setup [:create_admin_user, :login_user, :create_event]

    test "shows the index page", %{conn: conn} do
      conn =
        conn
        |> get(Routes.admin_path(conn, :index))

      assert html_response(conn, 200)
      assert Routes.admin_path(conn, :index) == conn.request_path
    end
  end

  describe "accessing :index with a member account" do
    setup [:create_user, :login_user, :create_event]

    test "shows the index page", %{conn: conn} do
      conn =
        conn
        |> get(Routes.admin_path(conn, :index))

      assert html_response(conn, 302)
      assert Routes.member_path(conn, :index) == redirected_to(conn)
    end
  end

  describe "accessing :events" do
    setup [:create_admin_user, :login_user, :create_event, :create_second_event]

    test "shows a list of all events", %{conn: conn, event: event, event2: event2} do
      conn =
        conn
        |> get(Routes.admin_path(conn, :index))

      assert html_response(conn, 200) =~ "Event navn"
      assert html_response(conn, 200) =~ event.name
      assert html_response(conn, 200) =~ event2.name
      assert html_response(conn, 200) =~ "Endre"
    end
  end

  describe "accessing :new_event" do
    setup [:create_admin_user, :login_user]

    test "shows that we can create new event", %{conn: conn} do
      conn =
        conn
        |> get(Routes.admin_path(conn, :new_event))

      assert html_response(conn, 200) =~ "Lag event"
    end
  end

  describe ":create_event" do
    setup [:create_admin_user, :login_user]

    test "works as expected with valid parameters", %{conn: conn} do
      conn =
        conn
        |> post(Routes.admin_path(conn, :create_event), event: EventHelper.get_event_data())
      
      events = Events.get_events()
      event = hd(events)

      assert 1 == length(events)
      assert Routes.admin_path(conn, :edit_event, event.id) == redirected_to(conn, 302)
    end

    test "does not create a new event when given invalid paramters", %{conn: conn} do
      conn =
        conn
        |> post(Routes.admin_path(conn, :create_event), event: %{name: nil, start: nil, end: nil})

      assert Routes.admin_path(conn, :new_event) == conn.request_path
      refute 1 == length(Events.get_events())
    end

    test "returns 404 if event-data is not passed as a parameter", %{conn: conn} do
      conn =
        conn
        |> post(Routes.admin_path(conn, :create_event))

      assert html_response(conn, 404)
    end
  end

  describe ":edit_event" do
    setup [:create_admin_user, :login_user, :create_event]

    test "renders edit page if given a valid event_id", %{conn: conn, event: event} do
      conn =
        conn
        |> get(Routes.admin_path(conn, :edit_event, event.id))

      assert html_response(conn, 200) =~ "Start dato"
      assert html_response(conn, 200) =~ event.name
    end

    test "redirects if there is no event with the given id", %{conn: conn} do
        conn
        |> get(Routes.admin_path(conn, :edit_event, 1997))
        |> html_response(404)
        |> assert
    end
  end

  describe ":update_event" do
    setup [:create_admin_user, :login_user, :create_event]

    test "Update events when given valid parameters", %{conn: conn, event: event} do
      conn =
        conn
        |> put(Routes.admin_path(conn, :update_event, event.id),
          event: %{name: "new name"}
        )

      {:ok, updated_event} = Events.get_event(event.id)

      assert html_response(conn, 200) =~ "Eventet har blitt oppdatert."
      assert "new name" == updated_event.name
    end

    test "throws when given invalid id", %{conn: conn} do
      invalid_event_id = 123

      conn
      |> put(Routes.admin_path(conn, :update_event, invalid_event_id),
        event: %{name: "new name"}
      )
      |> html_response(404)
      |> assert
      
    end

    test "throws when given invalid new data", %{conn: conn, event: event} do
      conn =
        conn
        |> put(Routes.admin_path(conn, :update_event, event.id),
          event: %{end: event.start}
        )

      assert html_response(conn, 200)
      assert Routes.admin_path(conn, :edit_event, event.id) == conn.request_path
    end

    test "throws 404 when missing paramters", %{conn: conn, event: event} do
        conn
        |> put(Routes.admin_path(conn, :update_event, event.id))
        |> html_response(404)
        |> assert
    end
  end

  defp create_admin_user(params), do: AccountHelper.create_admin_user(params)
  defp create_user(params), do: AccountHelper.create_user(params)
  defp login_user(params), do: AccountHelper.login_user(params)
  defp create_event(_params), do: EventHelper.create_event()
  defp create_second_event(_params), do: EventHelper.create_second_event()
end
