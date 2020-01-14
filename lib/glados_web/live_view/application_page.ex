defmodule GladosWeb.LiveView.ApplicationPage do
  @moduledoc """
  The liveview session handler for the application page.
  """

  use Phoenix.LiveView
  alias Glados.Toolbox

  @questions_path "./priv/yaml/crew_application.yaml"

  def render(assigns) do
    Phoenix.View.render(GladosWeb.MemberView, "application_page.html", assigns)
  end

  def mount(%{}, socket) do
    {:ok, questions} =
      @questions_path
      |> YamlElixir.read_from_file()
      |> OK.map(&Toolbox.Map.keys_to_atom/1)

    socket =
      socket
      |> assign(:page, 0)
      |> assign(:questions, questions)

    {:ok, socket}
  end
end
