defmodule GladosWeb.MemberView do
  use GladosWeb, :view

  @doc """
  Given a question type, return the relevant template file name.
  """
  def gen_input_file(type), do: "application_input_#{type}.html"

  @doc """
  Returns a boolean indicating if the current page is complete.
  """
  def is_page_complete?(page, categorized_pages), do: categorized_pages[page] == :complete

  @doc """
  Returns a boolean indicating if the current page is the first page.
  """
  def is_first_page?(page, page_order), do: hd(page_order) == page

  @doc """
  Returns a boolean indicating if the current page is the last page.
  """
  def is_last_page?(page, page_order), do: List.last(page_order) == page
end
