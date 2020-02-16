defmodule Glados.Toolbox.Map do
  @moduledoc """
  Defines extra functions for handling maps.
  """

  @doc """
  Converts all map keys to atoms. This handles nested maps aswell.

  # example

  iex > keys_to_atom(%{"key" => "value"})
  %{key: "value"}

  iex > keys_to_atom(%{"key" => %{"key" => "value"}})
  %{key: %{key: "value"}}

  iex >  keys_to_atom(:not_a_map)
  :not_a_map
  """
  def keys_to_atom(%{} = map) do
    Enum.map(map, fn
      {key, value} when is_bitstring(key) -> {String.to_atom(key), keys_to_atom(value)}
      {key, value} -> {key, keys_to_atom(value)}
    end)
    |> Map.new()
  end

  def keys_to_atom(not_map), do: not_map

  def keys_to_integer(%{} = map) do
    Enum.map(map, fn
      {key, value} when is_bitstring(key) ->
        case Integer.parse(key) do
          :error -> key
          {number, _} -> {number, keys_to_integer(value)}
        end

      {key, value} ->
        {key, keys_to_integer(value)}
    end)
    |> Map.new()
  end

  def keys_to_integer(not_map), do: not_map
end
