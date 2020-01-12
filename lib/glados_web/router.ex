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

  pipeline :fetch_event do
    plug(GladosWeb.Plugs.FetchEvent)
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
    get("/registrer", AccountController, :new)
    post("/registrer", AccountController, :create)
    get("/glemtpassord", AccountController, :forgotten_password)
    post("/glemtpassord", AccountController, :send_email_for_new_password)
    get("/endrepassord", AccountController, :change_password)
    put("/endrepassord", AccountController, :set_new_password)
  end

  scope "/", GladosWeb do
    pipe_through [:browser, :guest, :verify]
    get("/verifiser", AccountController, :verify_email)
  end

  # Scope for transaction logger account
  scope "/logger", GladosWeb do
    pipe_through [:browser, :logger]

    get("/transactions", LoggerController, :logger_transactions)
    post("/transactions", LoggerController, :create_transaction)
    get("/delete/:id", LoggerController, :delete_transaction)
  end

  # Scope for verifying a new account
  scope "/", GladosWeb do
    pipe_through [:browser]

    get("/verifikasjonsendt", AccountController, :send_email_verification)
  end

  # Log out scope
  scope "/", GladosWeb do
    pipe_through [:browser, :auth]

    get("/logout", SessionController, :delete)
  end

  # Member Scope
  scope "/", GladosWeb do
    pipe_through [:browser, :member]

    get("/hovedside", MemberController, :index)
    get("/profil/informasjon", AccountController, :edit)
    put("/profil/informasjon", AccountController, :update_user)
  end

  scope "/:event_id", GladosWeb do
    pipe_through [:browser, :member, :fetch_event]

    get("/forside", MemberController, :event_landing)
  end

  # Crew Scope

  # Chief Scope

  # Admin Scope
  scope "/admin", GladosWeb do
    pipe_through [:browser, :admin]

    get("/", AdminController, :index)

    get("/crew", LoggerController, :logger_crew)
    post("/crew", LoggerController, :add_logger_crew)
    get("/crew/delete/:id", LoggerController, :delete_logger_crew)

    get("/transactions", LoggerController, :logger_transactions)
    post("/transactions", LoggerController, :create_transaction)
    get("/delete/:id", LoggerController, :delete_transaction)

    get("/eventer", AdminController, :events)
    get("/eventer/new", AdminController, :new_event)
    post("/eventer/new", AdminController, :create_event)
    get("/eventer/:event_id/rediger", AdminController, :edit_event)
    put("/eventer/:event_id/rediger", AdminController, :update_event)
  end
end
