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

    render(conn, "logger_crew.html",
      conn: conn,
      changeset: changeset,
      layout: {GladosWeb.LayoutView, "no_nav.html"}
    )
  end

  @doc """
  Adds crew member to list of crew
  """
  def add_logger_crew(conn, %{"logger_crew" => crew_params}) do
    IO.inspect(crew_params)

    case Glados.Logs.create_user(crew_params) do
      {:ok, user} ->
        conn
        |> redirect(Routes.logger_path(conn, :logger_crew))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html",
          changeset: changeset,
          layout: {GladosWeb.LayoutView, "no_nav.html"}
        )
    end
  end
end
