defmodule GladosWeb.AccountController do
  @moduledoc """
  Controller for handling actions related to a unique user.
  """
  use GladosWeb, :controller

  alias Ecto.Changeset
  alias Glados.Accounts.{Encryption, User}
  alias Glados.{Accounts, EmailSender}
  alias GladosWeb.Endpoint

  @doc """
  Path to display form for creating a new user
  """
  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset, layout: {GladosWeb.LayoutView, "dark_bg.html"})
  end

  @doc """
  Path to create a new user, given a set of params
  """
  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_session(:unverified_user, user.id)
        |> redirect(to: Routes.account_path(conn, :send_email_verification))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html",
          changeset: changeset,
          layout: {GladosWeb.LayoutView, "dark_bg.html"}
        )
    end
  end

  def send_email_verification(conn, _params) do
    conn
    |> get_session(:unverified_user)
    |> case do
      nil ->
        render_404(conn)

      user_id ->
        user_id
        |> Accounts.get_user!()
        |> EmailSender.send_verification()

        render(conn, "sent_verify.html", layout: {GladosWeb.LayoutView, "dark_bg.html"})
    end
  end

  @doc """
  Path to verify user when a token is passed in
  """
  def verify_email(conn, %{"token" => token}) do
    with {:ok, user_id} <- Glados.Token.verify_new_account_token(token),
         %User{verified: false} = user <- Glados.Accounts.get_user!(user_id) do
      Glados.Accounts.validate_user(user)

      conn
      |> put_flash(:info, "Din bruker er nå verifisert!")
      |> redirect(to: Routes.session_path(conn, :new))
    else
      %User{verified: true} ->
        conn
        |> put_flash(:error, "Din bruker er allerede verifisert.")
        |> redirect(to: Routes.session_path(conn, :new))

      _ ->
        conn
        |> put_flash(:error, "Verifikasjons-lenken er ugyldig.")
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end

  @doc """
  Path to verify user when there is no token passed in
  """
  def verify_email(conn, _) do
    render_404(conn)
  end

  @doc """
  Path to send email verification email
  """
  def forgotten_password(conn, _params) do
    render(conn, "forgotten_password.html", layout: {GladosWeb.LayoutView, "dark_bg.html"})
  end

  def send_email_for_new_password(conn, %{"email" => email}) do
    case Glados.Accounts.get_user_by_email(email) do
      {:ok, user} ->
        EmailSender.send_password_reset(user)

        conn
        |> put_flash(:info, "Email er sendt.")
        |> redirect(to: Routes.account_path(Endpoint, :forgotten_password))

      {:error, :nil_value} ->
        conn
        |> put_flash(:error, "Fant ingen bruker med denne epost addressen.")
        |> redirect(to: Routes.account_path(Endpoint, :forgotten_password))

      _ ->
        conn
        |> put_flash(:error, "En feil oppstod. Prøv igjen senere.")
        |> render(to: Routes.account_path(Endpoint, :forgotten_password))
    end
  end

  @doc """
  Path for a user to change their password
  """
  def change_password(conn, %{"token" => token}) do
    with {:ok, user_id} <- Glados.Token.set_new_password_token(token),
         %User{} = user <- Glados.Accounts.get_user!(user_id) do
      changeset = Glados.Accounts.change_password(user)

      render(conn, "new_password.html",
        layout: {GladosWeb.LayoutView, "dark_bg.html"},
        changeset: changeset,
        user_id: user.id
      )
    end
  end

  @doc """
  Post path for changing password
  """
  def set_new_password(conn, %{"user" => user_params}) do
    user_params["user_id"]
    |> Accounts.get_user!()
    |> Accounts.update_password(user_params)
    |> case do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Passordet er endret!")
        |> redirect(to: Routes.session_path(Endpoint, :new))

      {:error, changeset} ->
        conn
        |> render("new_password.html",
          layout: {GladosWeb.LayoutView, "dark_bg.html"},
          changeset: changeset,
          user_id: changeset.data.id
        )
    end
  end

  @doc """
  Path to display form for editing a user
  """
  def edit(conn, _params) do
    user = conn.assigns.user

    info_changeset = Accounts.change_info(user)
    password_changeset = Accounts.change_password(user)

    render(
      conn,
      "edit.html",
      user: user,
      info_changeset: info_changeset,
      password_changeset: password_changeset
    )
  end

  @doc """
  Path to update a user, given a set of parameters
  """
  def update_user(conn, %{"user" => %{"name" => _} = user_params}) do
    user = conn.assigns.user

    Accounts.update_user_info(user, user_params)
    |> case do
      {:ok, _user} ->
        conn
        |> put_flash(:info_updated, "Bruker info ble oppdatert.")
        |> redirect(to: Routes.account_path(conn, :edit))

      {:error, %Ecto.Changeset{} = info_changeset} ->
        password_changeset = Accounts.change_password(user)

        conn
        |> put_flash(:info_not_updated, "Bruker info ble ikke oppdatert.")
        |> render(
          "edit.html",
          user: user,
          info_changeset: info_changeset,
          password_changeset: password_changeset
        )
    end
  end

  def update_user(conn, %{"user" => %{"old_password" => old_password} = password_params}) do
    user = conn.assigns.user

    if Encryption.valid_password?(user, old_password) do
      update_password_and_render(conn, user, password_params)
    else
      info_changeset = Accounts.change_info(user)
      password_changeset = wrong_pw_changeset(user, password_params)
      not_updated_password(conn, info_changeset, password_changeset)
    end
  end

  defp update_password_and_render(conn, %User{} = user, params) do
    case Accounts.update_password(user, params) do
      {:ok, _user} ->
        conn
        |> put_flash(:password_updated, "Passordet ble oppdatert.")
        |> redirect(to: Routes.account_path(conn, :edit))

      {:error, %Ecto.Changeset{} = password_changeset} ->
        info_changeset = Accounts.change_info(user)
        not_updated_password(conn, info_changeset, password_changeset)
    end
  end

  defp wrong_pw_changeset(user, params) do
    Accounts.change_password(user, params)
    |> Changeset.add_error(:old_password, "Dette passordet stemmer ikke.")
  end

  defp not_updated_password(conn, info_changeset, password_changeset) do
    conn
    |> put_flash(:password_not_updated, "Passordet ble ikke oppdatert.")
    |> render(
      "edit.html",
      user: info_changeset.data,
      info_changeset: info_changeset,
      password_changeset: password_changeset
    )
  end

  defp render_404(conn) do
    conn
    |> put_status(:not_found)
    |> put_view(GladosWeb.ErrorView)
    |> render("404.html")
  end
end
