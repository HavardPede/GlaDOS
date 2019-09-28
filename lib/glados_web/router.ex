defmodule GladosWeb.Router do
  use GladosWeb, :router

  alias GladosWeb.Plugs.Guest
  alias GladosWeb.Plugs.Auth
  alias GladosWeb.Plugs.Verify

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  # Scope for login page
  scope "/", GladosWeb do
    pipe_through [:browser, Guest]

    get("/", SessionController, :new)
    post("/", SessionController, :create)

    get("/registrer", UserController, :new)
    post("/registrer", UserController, :create)
  end

  scope "/logger", GladosWeb do
    pipe_through [:browser]

    get("/", LoggerController, :index)
    post("/", LoggerController, :add_purchase)
  end

  # Scope for verifying a new user
  scope "/", GladosWeb do
    pipe_through [:browser, Verify]

    get("/verifikasjonsendt", UserController, :send_email_verification)
    get("/verifiser", UserController, :verify_email)
  end

  # Member Scope
  scope "/", GladosWeb do
    pipe_through [:browser, Auth]

    resources "/bruker", UserController, only: [:index, :show, :edit, :update, :delete]
    get("/logout", SessionController, :delete)
  end

  # Crew Scope

  # Chief Scope

  # Admin Scope
  scope "/admin", GladosWeb do
    pipe_through [:browser]

    get("/logger/crew", LoggerController, :logger_crew)
    post("/logger/crew", LoggerController, :add_logger_crew)
    get("/logger/crew/delete/:id", LoggerController, :delete_logger_crew)

    get("/logger/transactions", LoggerController, :logger_transactions)
    post("/logger/transactions", LoggerController, :add_logger_transaction)
  end
end
