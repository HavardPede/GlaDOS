defmodule Glados.Toolbox.MapTest do
  use Glados.DataCase

  alias Glados.Toolbox.Map

  describe "keys_to_atom/1" do
    test "works on 1-depth map",
      do: assert(%{key: :value} == Map.keys_to_atom(%{"key" => :value}))

    test "works on n-depth map",
      do: assert(%{key: %{key: :value}} == Map.keys_to_atom(%{"key" => %{"key" => :value}}))

    test "works on n-depth map when some levels already have atom keys",
      do: assert(%{key: %{key: :value}} == Map.keys_to_atom(%{key: %{"key" => :value}}))

    test "does not convert value to atom",
      do: refute(%{key: :value} == Map.keys_to_atom(%{"key" => "value"}))

    test "returns map when all keys are atom",
      do: assert(%{key: :value} == Map.keys_to_atom(%{key: :value}))
  end
end
