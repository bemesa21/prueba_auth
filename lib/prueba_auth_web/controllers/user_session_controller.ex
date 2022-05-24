defmodule PruebaAuthWeb.UserSessionController do
  use PruebaAuthWeb, :controller

  alias PruebaAuth.Accounts
  alias PruebaAuthWeb.UserAuth

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params |> IO.inspect(label: :params)

    user = Accounts.get_user_by_email_and_password(email, password)

    UserAuth.log_in_user(conn, user, user_params)
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
