defmodule GladosWeb.LiveView.ApplicationPage do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    Current temperature: <%= @message %>
    """
  end

  def mount(%{message: message}, socket) do
    {:ok, assign(socket, :message, message)}
  end
end
