defmodule Glados.CrewApplications do
  @moduledoc """
  Defines higher order logic for crew applications.
  """
  alias Glados.Toolbox

  @questions_per_page 3
  @questions_path "./priv/yaml/crew_application.yaml"

  @doc """
  Returns a nested map of data for rendering the questions for a crew application.
  """
  def get_questions do
    {:ok, questions} =
      @questions_path
      |> YamlElixir.read_from_file()
      |> OK.map(&Toolbox.Map.keys_to_atom/1)

    questions
  end

  @doc """
  Returns an integer representing how many questions should be rendered per page.
  """
  def questions_per_page, do: @questions_per_page

  @doc """
  Returns an integer representing how many pages the application flow will have.
  """
  def page_count do
    get_questions
    |> Map.keys()
    |> length()
    |> Kernel./(questions_per_page())
    |> Float.ceil()
    |> trunc()
  end

  @doc """
  Creates a map where each question maps to an empty value.
  """
  def create_answers_map do
    get_questions
    |> Map.keys()
    |> Enum.map(&{&1, ""})
    |> Map.new()
  end
end
