defmodule GladosWeb.LoggerController do
  use GladosWeb, :controller
  alias Glados.Logger.LoggerCrew

  @doc """
  Displays the logger page with the last 20 transactions
  """
  def index(conn, _params) do
    render(conn, "index.html")
  end

  @doc """
  Adds purchase to the logger page
  """
  def add_purchase(conn, _params) do
    render(conn, "index.html")
  end

  @doc """
  Displays all crew members that are linked with the logger
  """
  def logger_crew(conn, _params) do
    changeset = LoggerCrew.changeset(%LoggerCrew{}, %{})
    users = Glados.Logs.list_users() |> Enum.reverse()

    render(conn, "logger_crew.html",
      conn: conn,
      changeset: changeset,
      users: users,
      layout: {GladosWeb.LayoutView, "no_nav.html"}
    )
  end

  @doc """
  Adds crew member to list of crew
  """
  def add_logger_crew(conn, %{"logger_crew" => crew_params}) do
    case Glados.Logs.create_user(crew_params) do
      {:ok, user} ->
        conn
        |> redirect(to: Routes.logger_path(conn, :logger_crew))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "This user already exists")
        |> redirect(to: Routes.logger_path(conn, :logger_crew))
    end
  end

  def delete_logger_crew(conn, %{"id" => crew_id}) do
    crew_member = Glados.Logs.get_crew!(crew_id)
    IO.inspect(crew_member)

    case Glados.Logs.delete_logger_crew(crew_member) do
      {:ok, struct} ->
        conn
        |> put_flash(:info, "User deleted successfully")
        |> redirect(to: Routes.logger_path(conn, :logger_crew))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "User couldn't be deleted")
        |> redirect(to: Routes.logger_path(conn, :logger_crew))
    end
  end
end
