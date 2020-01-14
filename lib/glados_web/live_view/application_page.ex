defmodule GladosWeb.LiveView.ApplicationPage do
  use Phoenix.LiveView

  alias Glados.Toolbox

  @questions_path "./priv/yaml/crew_application.yaml"

  def render(assigns) do
    Phoenix.View.render(GladosWeb.MemberView, "application_page.html", assigns)
  end

  def mount(%{message: message}, socket) do
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
