defmodule PruebaAuthWeb.ProfileLive do
  use PruebaAuthWeb, :live_view

  on_mount {PruebaAuthWeb.UserAuth, :mount_current_user}

  def render(assigns) do
    ~H"""
    <%= @current_user.email %>!

    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
