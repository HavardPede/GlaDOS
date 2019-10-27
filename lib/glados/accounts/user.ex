defmodule Glados.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Kernel
  alias Glados.Accounts.Encryption
  alias Glados.Events.{Event, EventCrew}

  @missing_field "Du må fylle inn dette feltet."

  @primary_key {:id, :binary_id, auto_generate: false}
  schema "users" do
    field(:name, :string, null: false)
    field(:email, :string, null: false)
    field(:username, :string, null: false)
    field(:address, :string)
    field(:postcode, :integer)
    field(:phone_number, :string)
    field(:auth_level, :integer)
    field(:verified, :boolean)

    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)
    field(:encrypted_password, :string)

    field(:day, :string, virtual: true)
    field(:month, :string, virtual: true)
    field(:year, :string, virtual: true)
    field(:dob, :date)

    many_to_many(:event, Event, join_through: EventCrew, on_replace: :delete)

    timestamps()
  end

  def password_changeset(user, attrs) do
    user 
    |> cast(attrs, [:password, :password_confirmation])
    |> validate_required([:password, :password_confirmation], message: @missing_field)
    |> validate_password()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :name,
      :username,
      :encrypted_password,
      :day,
      :month,
      :year,
      :email,
      :address,
      :postcode,
      :phone_number,
      :password,
      :password_confirmation,
      :auth_level,
      :verified,
      :id
    ])
    |> validate_required(
      [
        :id,
        :name,
        :username,
        :postcode,
        :phone_number,
        :day,
        :month,
        :year,
        :email,
        :address,
        :auth_level,
        :verified,
        :password,
        :password_confirmation
      ],
      message: @missing_field
    )
    |> validate_username()
    |> validate_password()
    |> validate_name()
    |> validate_email()
    |> set_dob()
    |> validate_phone_number()
    |> validate_postcode()
    |> validate_number(:auth_level, less_than: 5)
    |> encrypt_password()
    |> validate_required(:encrypted_password)
  end

  def verified_changeset(user, attrs) do
    user
    |> cast(attrs, [:verified])
    |> validate_required([:verified])
  end

  # Password validation
  defp validate_password(%{changes: %{password: password}} = changeset) do
    # Check length and content and return only 1 error even if both fails. If all is fine, return changeset
    length = String.length(password) > 7
    content = String.match?(password, ~r/(?=.*[a-å])(?=.*[A-Å])(?=.*[0-9])/)

    case {length, content} do
      {false, _} ->
        add_error(changeset, :password, "Passordet må være minst 8 karakterer langt.")

      {_, false} ->
        add_error(
          changeset,
          :password,
          "Passordet må inneholde minst 1 liten og stor bokstav, og ett tall."
        )

      {true, true} ->
        validate_confirmation(changeset, :password, message: "Passordet stemmer ikke.")
    end
  end

  # If password is not in changeset, simply return changeset
  defp validate_password(changeset), do: changeset

  # Validate that email format is correct
  defp validate_email(%{changes: %{email: _}} = changeset) do
    changeset
    |> validate_format(:email, ~r/[^@]+@[^\.]+\..+/,
      message: "Du må oppgi en gyldig epost adresse."
    )
    |> unique_constraint(:email, message: "Epost-adressen er allerede i bruk.")
  end

  defp validate_email(changeset), do: changeset

  # validate that username format is correct
  defp validate_username(%{changes: %{username: username}} = changeset) do
    changeset = downcase_username(changeset)
    username = String.downcase(username)

    length = String.length(username)
    format = String.match?(username, ~r/^[a-zæøå[:alnum:]]+$/)

    case {length >= 5 && length <= 20, format} do
      {false, _} ->
        add_error(changeset, :username, "Brukernavnet må være mellom 5 og 20 karakterer.")

      {_, false} ->
        add_error(changeset, :username, "Brukernavnet kan kun inneholde bokstaver og tall.")

      {true, true} ->
        unique_constraint(changeset, :username, message: "Brukernavnet er allerede i bruk.")
    end
  end

  # Only called if username is not in changeset
  defp validate_username(changeset), do: changeset

  # Name validation
  defp validate_name(%{changes: %{name: _}} = changeset) do
    changeset
    |> validate_format(
      :name,
      ~r/^([a-zæøåA-ZÆØÅ]+[[:space:]]{1}[a-zæøåA-ZÆØÅ]+)+$/,
      message: "Du må oppgi både fornavn og etternavn, kun som bokstaver."
    )
  end

  defp validate_name(changeset), do: changeset

  defp validate_phone_number(%{changes: %{phone_number: _}} = changeset) do
    changeset
    |> remove_whitespace(:phone_number)
    |> validate_format(
      :phone_number,
      ~r/([+]([0-9]{1,3})[[:space:]]?)?([0-9]{3})[[:space:]]?([0-9]{2})[[:space:]]?([0-9]{3,5})/,
      message: "Telefonnummer må være gyldig"
    )
  end

  defp validate_phone_number(changeset), do: changeset

  defp validate_postcode(%{changes: %{postcode: _}} = changeset) do
    changeset
    |> validate_number(:postcode,
      less_than: 10000,
      greater_than: 999,
      message: "Postnummer må være en 4-sifret kode."
    )
  end

  # Only called if changeset dont have postcode
  defp validate_postcode(changeset), do: changeset

  # Validation for date of birth
  defp set_dob(%{changes: %{day: day, month: month, year: year}} = changeset) do
    date = 
    [year, month, day]
    |> Enum.join("-")

    with {:ok, dob} <- Timex.parse(date, "%Y-%m-%d", :strftime),
      true <- valid_age?(dob)
    do
      put_change(changeset, :dob, Timex.to_date(dob))
    else
      _ -> add_error(changeset, :dob, "Dato er ikke gyldig.")
    end
  end

  defp set_dob(changeset), do: changeset

  def valid_age?(date_of_birth) do
    today = Date.utc_today()
    age = Timex.diff(today, date_of_birth, :years)
    age < 120 && age > 10
  end

  defp encrypt_password(changeset) do
    password = get_change(changeset, :password)

    if password do
      encrypted_password = Encryption.hash_password(password)
      put_change(changeset, :encrypted_password, encrypted_password)
    else
      changeset
    end
  end

  defp downcase_username(changeset) do
    update_change(changeset, :username, &String.downcase/1)
  end

  defp remove_whitespace(changeset, value) do
    update_change(changeset, value, &String.replace(&1, ~r/ +/, ""))
  end
end
