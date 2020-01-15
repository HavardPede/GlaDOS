defmodule GladosWeb.MemberView do
  use GladosWeb, :view

  alias GladosWeb.Endpoint

  @doc """
  Given a page, returns the list of questions that should be represented.
  """
  def get_question_numbers(page) when is_number(page) do
    questions_per_page = Glados.CrewApplications.questions_per_page()
    start = (page - 1) * questions_per_page + 1
    ending = start + questions_per_page - 1
    start..ending
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

  @doc """
  Given a question type, return the relevant template file name.
  """
  def gen_input_file(type), do: "application_input_#{type}.html"

  def activate_next_btn?(page_number, answers) do
    page_number
    |> get_question_numbers
    |> Enum.all?(&question_answered?(&1, answers))
  end

  defp question_answered?(question_number, answers) do
    answers[question_atom(question_number)] != ""
  end
end
