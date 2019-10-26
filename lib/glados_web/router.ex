defmodule GladosWeb.Router do
  use GladosWeb, :router

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

  pipeline :auth do
    plug(GladosWeb.Plugs.Auth)
  end

  pipeline :verify do
    plug(GladosWeb.Plugs.Verify)
  end

  pipeline :guest do
    plug(GladosWeb.Plugs.Guest)
  end

  pipeline :member do
    plug(GladosWeb.Plugs.Auth)
    plug(GladosWeb.Plugs.Member)
  end

  pipeline :logger do
    plug(GladosWeb.Plugs.Auth)
    plug(GladosWeb.Plugs.LoggerAuth)
  end

  pipeline :admin do
    plug(GladosWeb.Plugs.Auth)
    plug(GladosWeb.Plugs.Admin)
  end

  # Scope for login page
  scope "/", GladosWeb do
    pipe_through [:browser, :guest]

    get("/", SessionController, :new)
    post("/", SessionController, :create)

    get("/registrer", UserController, :new)
    post("/registrer", UserController, :create)

    get("/verifiser", UserController, :verify_email)
  end

  # Scope for transaction logger account
  scope "/logger", GladosWeb do
    pipe_through [:browser, :logger]

    get("/transactions", LoggerController, :logger_transactions)
    post("/transactions", LoggerController, :create_transaction)
    get("/delete/:id", LoggerController, :delete_transaction)
  end

  # Scope for verifying a new user
  scope "/", GladosWeb do
    pipe_through [:browser]

    get("/verifikasjonsendt", UserController, :send_email_verification)
  end

  # Log out scope
  scope "/", GladosWeb do
    pipe_through [:browser, :auth]
    get("/logout", SessionController, :delete)
  end

  # Member Scope
  scope "/", GladosWeb do
    pipe_through [:browser, :member]
    resources "/profil", UserController, only: [:index]
  end

  # Crew Scope

  # Chief Scope

  # Admin Scope
  scope "/admin", GladosWeb do
    pipe_through [:browser, :admin]
    get("/crew", LoggerController, :logger_crew)
    post("/crew", LoggerController, :add_logger_crew)
    get("/crew/delete/:id", LoggerController, :delete_logger_crew)

    get("/transactions", LoggerController, :logger_transactions)
    post("/transactions", LoggerController, :create_transaction)
    get("/delete/:id", LoggerController, :delete_transaction)

    get("/setup/event", AdminController, :events)
  end
end
