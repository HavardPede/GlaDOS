defmodule GladosWeb.LoggerController do
  use GladosWeb, :controller

  alias Glados.Logger.{CrewTransactions, LoggerCrew}

  @doc """
  Displays all crew members that are linked with the logger
  """
  def logger_crew(conn, _params) do
    changeset = LoggerCrew.changeset(%LoggerCrew{}, %{})
    users = Glados.Logs.list_logger_crew() |> Enum.reverse()

    render(conn, "logger_crew.html",
      conn: conn,
      changeset: changeset,
      users: users,
      layout: {GladosWeb.LayoutView, "dark_bg.html"}
    )
  end

  def logger_transactions(conn, _params) do
    user = conn.assigns.user
    changeset = CrewTransactions.changeset(%CrewTransactions{}, %{})

    logger? = user.account_type == "logger"

    transactions =
      Glados.Logs.get_all_crew_transactions()
      |> Enum.reverse()

    transactions =
      if logger? do
        Enum.take(transactions, 20)
      else
        transactions
      end

    crew = for member <- Glados.Logs.list_logger_crew(), into: %{}, do: Map.pop(member, :id)

    render(conn, "transactions.html",
      conn: conn,
      crew: crew,
      logger: logger?,
      changeset: changeset,
      transactions: transactions,
      layout: {GladosWeb.LayoutView, "dark_bg.html"}
    )
  end

  def create_transaction(conn, %{"crew_transactions" => transaction}) do
    transaction["logger_crew_id"]
    |> Glados.Logs.logger_crew_exists?()
    |> if do
      case Glados.Logs.create_logger_transaction(transaction) do
        {:ok, _transaction} ->
          conn
          |> redirect(to: Routes.logger_path(conn, :logger_transactions))
          |> halt()

        {:error, _} ->
          conn
          |> put_flash(:error, "Transaksjon ble ikke lagt til")
          |> redirect(to: Routes.logger_path(conn, :logger_transactions))
          |> halt()
      end
    else
      conn
      |> put_flash(:error, "Transaksjon ble ikke lagt til")
      |> redirect(to: Routes.logger_path(conn, :logger_transactions))
      |> halt()
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
        |> halt()

      {:error, _} ->
        conn
        |> put_flash(:error, "Crew medlem ble ikke lagt til.")
        |> redirect(to: Routes.logger_path(conn, :logger_crew))
        |> halt()
    end
  end

  def delete_transaction(conn, %{"id" => id}) do
    transaction = Glados.Logs.get_crew_transaction!(id)

    case Glados.Logs.delete_transaction(transaction) do
      {:ok, _struct} ->
        conn
        |> put_flash(:info, "Kjøp ble fjernet.")
        |> redirect(to: "/admin/transactions")
        |> halt()

      {:error, _} ->
        conn
        |> put_flash(:error, "Kjøp kunne ikke fjernes.")
        |> redirect(to: "/admin/transactions")
        |> halt()
    end
  end

  def delete_logger_crew(conn, %{"id" => crew_id}) do
    crew_member = Glados.Logs.get_logger_crew!(crew_id)

    case Glados.Logs.delete_logger_crew(crew_member) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Crew medlem ble fjernet.")
        |> redirect(to: Routes.logger_path(conn, :logger_crew))
        |> halt()

      {:error, _} ->
        conn
        |> put_flash(:error, "Crew medlem kunne ikke fjernes.")
        |> redirect(to: Routes.logger_path(conn, :logger_crew))
        |> halt()
    end
  end
end
