defmodule GladosWeb.NavigationView do
  use GladosWeb, :view

  alias GladosWeb.Endpoint
  alias GladosWeb.Router.Helpers, as: Routes
  import Phoenix.Controller

  @doc """
  Get page returns the selected page in the nav bar
  """
  def get_page(conn, account_type),
    do: get_page_for_controller(controller_module(conn), conn, account_type)

  ##
  ## MEMBER CONTROLLER
  ##
  defp get_page_for_controller(GladosWeb.MemberController, conn, "member") do
    case action_name(conn) do
      :event_landing -> {"forside", nil}
      :crew_application -> {"søknad", nil}
      _ -> {nil, nil}
    end
  end

  ##
  ## ACCOUNT CONTROLLER
  ##
  defp get_page_for_controller(GladosWeb.AccountController, _conn, "member"), do: {nil, nil}

  ##
  ## ADMIN CONTROLLER
  ##
  @info [:edit_event, :update_event]
  @crew [:view_crew, :set_crew_id]
  @cafeteria [:cafeteria, :handle_cafeteria_event, :delete_product]
  @applications [
    :view_applications,
    :toggle_applications,
    :review_application,
    :handle_application
  ]

  defp get_page_for_controller(GladosWeb.AdminController, conn, "admin") do
    case action_name(conn) do
      path when path in @info -> {"eventer", "event info"}
      path when path in @crew -> {"eventer", "crew"}
      path when path in @cafeteria -> {"eventer", "kantine"}
      path when path in @applications -> {"eventer", "søknader"}
      _ -> {"eventer", nil}
    end
  end

  @doc """
  Returns a map where the keys are the labels for a page, and the value is the href to said page
  """
  # The user has not yet selected an activation
  def get_pages("member", []), do: %{}

  def get_pages("member", role: "applicant", event_id: event_id) do
    %{
      "forside" => Routes.member_path(Endpoint, :event_landing, event_id),
      "søknad" => Routes.member_path(Endpoint, :crew_application, event_id)
    }
  end

  def get_pages("admin", _options) do
    %{
      "eventer" => Routes.admin_path(Endpoint, :index),
      "eslg" => "#"
    }
  end

  @doc """
  Returns a map where the keys are the labels for a sub-page, and the value is the href to said sub-page
  """
  def get_sub_pages(_account_type, nil, _opts), do: %{}

  def get_sub_pages("admin", "eventer", event_id: event_id) do
    %{
      "Event info" => Routes.admin_path(Endpoint, :edit_event, event_id),
      "Kantine" => Routes.admin_path(Endpoint, :cafeteria, event_id),
      "Søknader" => Routes.admin_path(Endpoint, :view_applications, event_id),
      "Crew" => Routes.admin_path(Endpoint, :view_crew, event_id)
    }
  end

  def get_sub_pages(account_type, page, opts), do: %{}
end
