defmodule PruebaAuthWeb.UserLoginLive do
  use PruebaAuthWeb, :live_view

  alias PruebaAuth.Accounts

  def render(assigns) do
    ~H"""
    <h1>Log in</h1>

    <.form let={f} for={:user} phx-submit="log_in" phx-trigger-action={@trigger_submit} action={Routes.user_session_path(@socket, :create)} as={:user}>
    <%= if @error_message do %>
        <div class="alert alert-danger">
        <p><%= @error_message %></p>
        </div>
    <% end %>

    <%= label f, :email %>
    <%= email_input f, :email, required: true %>

    <%= label f, :password %>
    <%= password_input f, :password, required: true %>

    <%= label f, :remember_me, "Keep me logged in for 60 days" %>
    <%= checkbox f, :remember_me %>

    <div>
        <%= submit "Log in" %>
    </div>
    </.form>

    <p>
    <%= link "Register", to: Routes.user_registration_path(@socket, :new) %> |
    <%= link "Forgot your password?", to: Routes.user_reset_password_path(@socket, :new) %>
    </p>
    """
  end

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       error_message: nil,
       trigger_submit: false
     )}
  end

  def handle_event("log_in", %{"user" => user_params}, socket) do
    %{"email" => email, "password" => password} = user_params

    if Accounts.get_user_by_email_and_password(email, password) do
      {:noreply, assign(socket, trigger_submit: true)}
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      {:noreply, assign(socket, :error_message, "Invalid email or password")}
    end
  end
end
