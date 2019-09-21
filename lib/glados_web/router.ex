defmodule GladosWeb.Router do
  use GladosWeb, :router

  alias GladosWeb.Plugs.Guest

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

    get("/verifikasjonsendt", UserController, :send_email_verification)
    get("/verifiser", UserController, :verify_email)
  end

  # Member Scope
  scope "/", GladosWeb do
    pipe_through [:browser, GladosWeb.Plugs.Auth]

    resources "/bruker", UserController, only: [:index, :show, :edit, :update, :delete]
    get("/logout", SessionController, :delete)
  end

  # Crew Scope

  # Chief Scope

  # Admin Scope
end
