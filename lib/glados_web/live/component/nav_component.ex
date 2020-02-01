defmodule GladosWeb.Live.Component.NavComponent do
  @moduledoc """
  The livecomponent for the admin nav bar.
  """
  use Phoenix.LiveComponent
  import GladosWeb.Router.Helpers
  alias GladosWeb.Endpoint
  alias GladosWeb.Live.View.EventsLiveView

  @events_index_page :eventer

  def mount(socket) do
    nav_elements = %{
      eslg: "#",
      eventer: live_path(socket, EventsLiveView),
      medlemmer: "#"
    }

    socket =
      socket
      |> assign(nav_elements: nav_elements)
      |> assign(current_page: @events_index_page)
      |> assign(current_sub_page: nil)
      |> assign(sub_pages: [])

    {:ok, socket}
  end

  def update(%{sub_pages: sub_pages, current_sub_page: current_sub_page}, socket) do
    socket
    |> assign(sub_pages: sub_pages)
    |> assign(current_sub_page: current_sub_page)
    |> OK.wrap()
  end

  def update(_assigns, socket) do
    OK.wrap(socket)
  end

  def render(assigns) do
    ~L"""
      <div class="bg-payne h-screen w-48 fixed text-white text-right flex flex-col justify-between">
        <div>
          <img src="<%= static_path(Endpoint, "/images/logo_70x.png" ) %>" class="h-12 mx-auto mt-5 mb-8" />
          <%= for {nav_text, nav_link} <- @nav_elements  do %>
            <div class="w-2/3 float-right uppercase py-2 pr-4 hover:text-cinderous border-cinderous <%= if nav_text == assigns.current_page, do: "border-b-2"%>"><a
                href="<%= nav_link %>"><%= nav_text %></a>
            </div>
            <%= if nav_text == assigns.current_page do %>
              <%= for page <- assigns.sub_pages do %>
                <div 
                  class="
                    w-2/3 float-right text-left capitalize text-xs py-2 px-4 
                    <%= if assigns.current_sub_page == page, do: "font-bold"%> 
                    cursor-pointer hover:text-cinderous
                  "
                  phx-click="change_page"
                  phx-value-page="<%= page %>"
                >
                  <%= page %>
                </div>
              <% end %> 
            <% end %>
          <% end %>
        </div>
        <a href="<%= session_path(Endpoint, :delete) %>" class="py-4 bg-cinderous uppercase hover:bg-moss text-center">
          Logg
          ut</a>
      </div>
    """
  end

  def handle_event("change_page", %{"page" => new_page}, socket) do
    send(self(), {:change_page, new_page})
    {:noreply, socket}
  end
end
