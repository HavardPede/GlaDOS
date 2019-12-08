defmodule Glados.Utils do
  @moduledoc """
  Defines helper functions
  """

  @doc """
  Returns a {:ok, value} tuple, if value is not nil, or {:error, :nil_value} if value is nil

  ## Example
  iex > nillable(nil)
  {:error, :nil_value}
    
  iex > nillable(:some_value)
  {:ok, :some_value}
  """
  def nillable(nil), do: {:error, :nil_value}
  def nillable(value), do: {:ok, value}
end
