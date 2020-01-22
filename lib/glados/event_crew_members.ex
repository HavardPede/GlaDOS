defmodule Glados.EventCrewMembers do
  @moduledoc """
  Defines logic for handling crew members per event.
  """
  alias Glados.Repo
  alias Glados.Events.EventCrewMember

  @doc """
  Returns the changeset for the given user
  """
  def change_event_crew_member(%EventCrewMember{} = member, params \\ %{}) do
    EventCrewMember.changeset(member, params)
  end

  @doc """
  Returns all event_crew_members.
  """
  def get_all_event_crew_members do
    Repo.all(EventCrewMember)
  end

  @doc """
  Returns a monad with a event_crew_member or nil.

  # Example
    iex > get_event_crew_member(user_id, event_id)
    {:ok, %EventCrewMember{}}

    iex > get_event_crew_member(nil, event_id)
    {:error, :does_not_exist}
  """
  def get_event_crew_member(user_id, event_id) do
    Repo.get_by(EventCrewMember, user_id: user_id, event_id: event_id)
    |> OK.required(:does_not_exist)
  end

  @doc """
  Creates the initial relationship between a user and an event.
  """
  def send_application(user_id, event_id, application) do
    change_event_crew_member(
      %EventCrewMember{},
      construct_application_params(user_id, event_id, application)
    )
    |> Repo.insert()
  end

  defp construct_application_params(user_id, event_id, application) do
    %{
      user_id: user_id,
      event_id: event_id,
      application: application,
      role: "applicant",
      id_card: nil
    }
  end
end
