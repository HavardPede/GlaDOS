defmodule Glados.Toolbox.List do
  @moduledoc """
  Contains extra functions to handle lists.
  """

  @doc """
  given a list and a list element, this function will remove all elements in the list that 
  has a higher index then the given element.

  example: 
    call: remove_trailing_elements([1, 2, 3], 2) 
    return: [1, 2]
  OBS! if there are duplicate elements, this function will pick the latter one.
  """
  def remove_trailing_elements(list, element) when Kernel.is_list(list) do
    list
    |> Enum.reverse()
    |> find_element_by_removing_head(element)
    |> Enum.reverse()
  end

  # Recursive function to remove the head of the list until element is found
  defp find_element_by_removing_head(list, element) do
    if hd(list) == element do
      list
    else
      list
      |> tl()
      |> find_element_by_removing_head(element)
    end
  end
end
