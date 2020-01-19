defmodule Glados.CrewApplications do
  @moduledoc """
  Defines higher order logic for crew applications.
  """
  alias Glados.Toolbox

  @questions_path "./priv/yaml/crew_application.yaml"

  @doc """
  Returns a nested map of data for rendering the questions for a crew application.
  """
  def get_pages do
    {:ok, questions} =
      @questions_path
      |> YamlElixir.read_from_file()
      |> OK.map(&Toolbox.Map.keys_to_atom/1)
      |> OK.map(&Map.delete(&1, :page_order))

    questions
  end

  def get_page_order do
    {:ok, page_order} =
      @questions_path
      |> YamlElixir.read_from_file()
      |> OK.map(&Toolbox.Map.keys_to_atom/1)
      |> OK.map(&Map.get(&1, :page_order))
      |> OK.map(fn pages -> Enum.map(pages, &String.to_atom/1) end)

    page_order
  end

  @doc """
  Returns an integer representing how many pages the application flow will have.
  """
  def page_count do
    get_pages
    |> Map.keys()
    |> length()
  end

  @doc """
  Creates a map where each question maps to an empty value.
  """
  def create_answers_map do
    get_pages
    |> Enum.map(fn {key, value} ->
      value =
        Enum.map(value, fn {inner_key, _} -> {inner_key, ""} end)
        |> Map.new()

      {key, value}
    end)
    |> Map.new()
  end

  @doc """
  Given a value, return an atom of structure :qV, where V is value.

  # example
  iex > question_atom(3)
  :q3
  """
  def question_atom(value) do
    "q#{value}"
    |> String.to_atom()
  end
end
