defmodule GladosWeb.Plugs.Verify do
  @moduledoc """
  This plug makes sure there exists an unverified user within the session.
  If there is no unverified user, throw 404.
  """

  require Logger
  import Plug.Conn
  import Phoenix.Controller
  alias Glados.Accounts
  alias GladosWeb.Plugs.PlugHelper
  alias GladosWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  # If there is an unverified session, fetch id and check if user is verified
  def call(%{private: %{plug_session: %{"unverified_user" => user_id}}} = conn, _opts) do
    user = Accounts.get_user!(user_id)

    if user.verified do
      conn
      |> put_flash(:error, "Din bruker er allerede verifisert.")
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt()
    else
      conn
    end
  end

  # If no unverified session, redirect
  def call(conn, _opts) do
    Logger.warn("No unverified account in session. throwing 404.")
    PlugHelper.throw_404(conn)
  end
end
