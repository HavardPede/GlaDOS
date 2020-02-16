defmodule GladosWeb.AccountView do
  use GladosWeb, :view

  def has_error(form, field) do
    error_tag(form, field) != []
  end
end
