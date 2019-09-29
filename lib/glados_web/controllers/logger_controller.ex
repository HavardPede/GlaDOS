defmodule GladosWeb.LoggerController do
  use GladosWeb, :controller
  alias Glados.Logger.LoggerCrew
  alias Glados.Logger.CrewTransactions

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
    users = Glados.Logs.list_logger_crew() |> Enum.reverse()

    render(conn, "logger_crew.html",
      conn: conn,
      changeset: changeset,
      users: users
    )
  end

  def logger_transactions(conn, _params) do
    current_user =
      Plug.Conn.get_session(conn, :current_user_id)
      |> current_user = Accounts.get_user!(user_id)

    changeset = CrewTransactions.changeset(%CrewTransactions{}, %{})

    transactions =
      Glados.Logs.get_all_crew_transactions()
      |> Enum.reverse()

    transactions =
      if(current_user["autn_level"] == 2) do
        Enum.take(transactions, 20)
      else
        transactions
      end

    crew = for member <- Glados.Logs.list_logger_crew(), into: %{}, do: Map.pop(member, :id)

    render(conn, "transactions.html",
      conn: conn,
      crew: crew,
      changeset: changeset,
      transactions: transactions,
      layout: {GladosWeb.LayoutView, "no_nav.html"}
    )
  end

  def create_transaction(conn, %{"crew_transactions" => transaction}) do
    case Glados.Logs.create_logger_transaction(transaction) do
      {:ok, _transaction} ->
        conn
        |> redirect(to: Routes.logger_path(conn, :logger_transactions))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Transaksjon ble ikke lagt til")
        |> redirect(to: Routes.logger_path(conn, :logger_transactions))
    end
  end

  @doc """
  Adds crew member to list of crew
  """
  def add_logger_crew(conn, %{"logger_crew" => crew_params}) do
    case Glados.Logs.create_logger_crew(crew_params) do
      {:ok, _user} ->
        conn
        |> redirect(to: Routes.logger_path(conn, :logger_crew))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Crew medlem ble ikke lagt til.")
        |> redirect(to: Routes.logger_path(conn, :logger_crew))
    end
  end

  def delete_transaction(conn, %{"id" => id}) do
    transaction = Glados.Logs.get_crew_transaction!(id)

    case Glados.Logs.delete_transaction(transaction) do
      {:ok, struct} ->
        conn
        |> put_flash(:info, "Kjøp ble fjernet.")
        |> redirect(to: Routes.logger_path(conn, :logger_transactions))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Kjøp kunne ikke fjernes.")
        |> redirect(to: Routes.logger_path(conn, :logger_transactions))
    end
  end

  def delete_logger_crew(conn, %{"id" => crew_id}) do
    crew_member = Glados.Logs.get_logger_crew!(crew_id)

    case Glados.Logs.delete_logger_crew(crew_member) do
      {:ok, struct} ->
        conn
        |> put_flash(:info, "Crew medlem ble fjernet.")
        |> redirect(to: Routes.logger_path(conn, :logger_crew))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Crew medlem kunne ikke fjernes.")
        |> redirect(to: Routes.logger_path(conn, :logger_crew))
    end
  end
end
