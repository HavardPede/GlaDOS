defmodule GladosWeb.Router do
  use GladosWeb, :router
  use Plug.ErrorHandler
  use Sentry.Plug

  import Phoenix.LiveView.Router
  alias GladosWeb.Plugs.{Admin, Auth, FetchEvent, Guest, LoggerAuth, Member, Verify}
  alias Live.View.LoggerLive

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug Phoenix.LiveView.Flash
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(NavigationHistory.Tracker)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :auth do
    plug(Auth)
  end

  pipeline :verify do
    plug(Verify)
  end

  pipeline :guest do
    plug(Guest)
  end

  pipeline :member do
    plug(Auth)
    plug(Member)
  end

  pipeline :logger do
    plug(Auth)
    plug(LoggerAuth)
    plug(:put_layout, {GladosWeb.LayoutView, "logger_layout.html"})
  end

  pipeline :admin do
    plug(Auth)
    plug(Admin)
  end

  pipeline :fetch_event do
    plug(FetchEvent)
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

  # Scope for verifying a new account
  scope "/", GladosWeb do
    pipe_through [:browser]

    get("/verifikasjonsendt", AccountController, :send_email_verification)
    get("/brukervilkar", TermsController, :terms_and_conditions)
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
    get("/profil", AccountController, :edit)
    put("/profil", AccountController, :update_user)
  end

  scope "/:event_id", GladosWeb do
    pipe_through [:browser, :member, :fetch_event]

    get("/forside", MemberController, :event_landing)
    get("/soknad", MemberController, :crew_application)
  end

  # Logger Scope
  scope "/logger", GladosWeb do
    pipe_through [:browser, :logger]

    live "/", LoggerLive
  end

  # Admin Scope
  scope "/admin/kontrollpanel", GladosWeb do
    pipe_through [:browser, :admin, :fetch_event]

    get("/eventer", AdminController, :index)
    get("/eventer/nytt", AdminController, :new_event)
    post("/eventer/nytt", AdminController, :create_event)

    get("/eventer/:event_id/rediger", AdminController, :edit_event)
    put("/eventer/:event_id/rediger", AdminController, :update_event)

    get("/eventer/:event_id/crew", AdminController, :view_crew)
    post("/eventer/:event_id/crew", AdminController, :set_crew_id)

    get("/eventer/:event_id/cafeteria", AdminController, :cafeteria)
    post("/eventer/:event_id/cafeteria", AdminController, :handle_cafeteria_event)
    delete("/eventer/:event_id/cafeteria/:product_id/delete", AdminController, :delete_product)

    get("/eventer/:event_id/soknader", AdminController, :view_applications)
    post("/eventer/:event_id/soknader", AdminController, :toggle_applications)
    get("/eventer/:event_id/soknader/:applicant_id", AdminController, :review_application)
    post("/eventer/:event_id/soknader/:applicant_id", AdminController, :handle_application)
  end
end
