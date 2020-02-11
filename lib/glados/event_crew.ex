defmodule Glados.EventCrew do
  @moduledoc """
  Defines logic for handling crew members per event.
  """

  import Ecto.Query, only: [from: 2]
  require OK
  alias Ecto.Changeset
  alias Glados.Events.EventCrewMember
  alias Glados.{Repo, EventCrew}
  @crew ["", "Kantine", "Security", "Info", "Scene", "Compo", "Ryddecrew"]
  @roles ["applicant", "member", "leader", "admin"]

  @doc """
  Returns the list of possible roles for a crew member.
  """
  def get_event_roles, do: @roles
  @doc """
  Returns the list of crew.
  """
  def get_crew_list, do: @crew


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
  Fetches all members linked with an event, both applicants and crew, and returns a Result type
  """
  @doc """
  Returns applicants that has yet to be accepted.
  Returns a monad.
  """
  def get_applicants(event_id) do
    from(applicant in EventCrewMember,
      where: applicant.role == "applicant" and applicant.event_id == ^event_id
    )
    |> Repo.all()
    |> Repo.preload([:event, :user])
    |> OK.wrap()
  end

  @doc """
  Returns all accepted crew members.
  returns a monad.
  """
  def get_crew(event_id) do
    from(applicant in EventCrewMember,
      where: applicant.role != "applicant" and applicant.event_id == ^event_id
    )
    |> Repo.all()
    |> Repo.preload([:user, :event])
    |> OK.wrap()
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
  Given a crew member, update the role
  """
  def set_role(%EventCrewMember{} = crew_member, role \\ "member") do
    if role in get_event_roles() do
      crew_member
      |> Changeset.change(role: role)
      |> Repo.update()
    else
      OK.failure(:invalid_role)
    end
  end

  @doc """
  Updates a crew member with new information
  """
  def update(%EventCrewMember{} = crew_member, updates) do
      crew_member
      |> Changeset.change(updates)
      |> Repo.update()
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
