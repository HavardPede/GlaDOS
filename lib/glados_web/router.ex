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

  scope "/", GladosWeb do
    pipe_through [:browser, GladosWeb.Plugs.Guest]

    resources "/nybruker", UserController, only: [:create, :new]
    get("/", PageController, :index)
    get "/login", SessionController, :new
    post "/login", SessionController, :create
  end

  scope "/", GladosWeb do
    pipe_through [:browser, GladosWeb.Plugs.Auth]

    get("/", PageController, :index)

    resources "/bruker", UserController, only: [:show, :edit, :update, :delete]
    get("brukere", UserController, :index)
    delete "/logout", SessionController, :delete
    get "/", PostController, :index
    get "/show", PageController, :show
  end
end
