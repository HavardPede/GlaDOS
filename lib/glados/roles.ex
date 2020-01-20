defmodule Glados.Roles do
  @moduledoc """
  Defines all logic related to event roles.
  """

  @roles ["applicant", "member", "leader", "admin"]
  def get_event_roles, do: @roles
end
