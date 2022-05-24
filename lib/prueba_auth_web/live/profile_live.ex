defmodule PruebaAuthWeb.ProfileLive do
  use PruebaAuthWeb, :live_view

  on_mount {TestAuthWeb.UserAuth, :mount_current_user}

  def render(assigns) do
    ~H"""
    <%= @current_user.email %>!

    """
  end

  def mount(_params, _session, socket) do
    %{current_user: current_user} = socket.assigns
    {:ok, socket}
  end
end
