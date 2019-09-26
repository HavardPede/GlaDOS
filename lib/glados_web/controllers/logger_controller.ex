defmodule GladosWeb.LoggerController do
  use GladosWeb, :controller

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
  def crew_members(conn, _params) do
    render(conn, "logger_crew.html")
  end

  @doc """
  Adds crew member to list of crew
  """
  def add_logger_crew(conn, _params) do
  end
end
