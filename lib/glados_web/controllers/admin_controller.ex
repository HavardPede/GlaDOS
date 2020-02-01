defmodule GladosWeb.AdminController do
  use GladosWeb, :controller

  alias Glados.Events
  alias Glados.Events.{Event}
  alias GladosWeb.Plugs.PlugHelper
  alias GladosWeb.Live

  plug :put_layout, "admin_layout.html"
end
