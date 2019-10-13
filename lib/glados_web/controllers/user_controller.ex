defmodule GladosWeb.UserController do
  use GladosWeb, :controller

  @moduledoc """
  Controller for handling actions related to a unique user.
  """

  alias Glados.Email
  alias Glados.Mailer
  alias Glados.Accounts
  alias Glados.Accounts.User

  @doc """
  Path to dispay all users
  """
  def index(conn, _params) do
    users = []
    render(conn, "index.html", users: users)
  end

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
        |> redirect(to: Routes.user_path(conn, :send_email_verification))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html",
          changeset: changeset,
          layout: {GladosWeb.LayoutView, "dark_bg.html"}
        )
    end
  end

  def send_email_verification(conn, _params) do
    user =
      conn
      |> get_session(:unverified_user)
      |> Accounts.get_user!()

    token = Glados.Token.generate_new_account_token(user)

    verification_url = Routes.user_url(conn, :verify_email, token: token)

    Email.verification_email(user.name, user.email, verification_url)
    |> Mailer.deliver_now()
    |> render("sent_verify.html",
      layout: {GladosWeb.LayoutView, "dark_bg.html"}
    )
  end

  @doc """
  Path to verify user when a token is passed in
  """
  def verify_email(conn, %{"token" => token}) do
    with {:ok, user_id} <- Glados.Token.verify_new_account_token(token),
         %User{verified: false} = user <- Glados.Accounts.get_user!(user_id) 
    do
      Glados.Accounts.validate_user(user)

      conn
      |> put_flash(:info, "Din bruker er nå verifisert!")
      |> redirect(to: "/")
    else
      %User{verified: true} ->
        conn
        |> put_flash(:error, "Din bruker er allerede verifisert.")
        |> redirect(to: "/")
      _ ->
        conn
        |> put_flash(:error, "Verifikasjons-lenken er ugyldig.")
        |> redirect(to: "/")
    end
  end

  @doc """
  Path to verify user when there is no token passed in
  """
  def verify_email(conn, _) do
  conn
  |> put_status(:not_found)
  |> put_view(GladosWeb.ErrorView)
  |> render("404.html")
  end

  @doc """
  Path to verify show a single user
  """
  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  @doc """
  Path to display form for editing a user
  """
  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  @doc """
  Path to update a user, given a set of parameters
  """
  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  @doc """
  Path to delete an account
  """
  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end
end
