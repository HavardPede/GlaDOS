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

  pipeline :logger do
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
  end

  # Scope for transaction logger account
  scope "/logger", GladosWeb do
    pipe_through [:browser, :logger]

    get("/", LoggerController, :index)
    post("/", LoggerController, :add_purchase)
  end

  # Scope for verifying a new user
  scope "/", GladosWeb do
    pipe_through [:browser, :verify]

    get("/verifikasjonsendt", UserController, :send_email_verification)
    get("/verifiser", UserController, :verify_email)
  end

  # Member Scope
  scope "/", GladosWeb do
    pipe_through [:browser, :auth]
    resources "/bruker", UserController, only: [:index]
    get("/logout", SessionController, :delete)
  end

  # Crew Scope

  # Chief Scope

  # Admin Scope
  scope "/admin", GladosWeb do
    pipe_through [:browser, :admin]

    get("/logger/crew", LoggerController, :logger_crew)
    post("/logger/crew", LoggerController, :add_logger_crew)
    get("/purchases", LoggerController, :view_all_purchases)
  end
end
