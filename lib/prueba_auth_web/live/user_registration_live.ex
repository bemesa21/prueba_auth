defmodule PruebaAuthWeb.UserRegistrationLive do
  use PruebaAuthWeb, :live_view

  alias PruebaAuth.Accounts
  alias PruebaAuth.Accounts.User

  def render(assigns) do
    ~H"""
    <h1>Register</h1>

    <.form let={f} for={@changeset} phx-submit="save" phx-trigger-action={@trigger_submit} action={Routes.user_session_path(@socket, :create)} as={:user}>
      <%= if @changeset.action do %>
        <div class="alert alert-danger">
          <p>Oops, something went wrong! Please check the errors below.</p>
        </div>
      <% end %>

      <%= label f, :email %>
      <%= email_input f, :email, required: true %>
      <%= error_tag f, :email %>

      <%= label f, :password %>
      <%= password_input f, :password, required: true %>
      <%= error_tag f, :password %>

      <div>
        <%= submit "Register" %>
      </div>
    </.form>

    <p>
      <%= link "Log in", to: Routes.user_login_path(@socket, :new) %> |
      <%= link "Forgot your password?", to: Routes.user_reset_password_path(@socket, :new) %>
    </p>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})
    {:ok, assign(socket, changeset: changeset, trigger_submit: false)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    IO.inspect(:on_save)

    case Accounts.register_user(user_params) |> IO.inspect(label: :register_user) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(socket, :edit, &1)
          )

        changeset = Accounts.change_user_registration(%User{}, user_params) |> IO.inspect(label: :user)
        socket =
          socket
          |> put_flash(:info, "User created successfully.")
          |> assign(:trigger_submit, true)
          |> assign(:changeset, changeset)

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
