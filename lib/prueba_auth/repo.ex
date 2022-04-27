defmodule PruebaAuth.Repo do
  use Ecto.Repo,
    otp_app: :prueba_auth,
    adapter: Ecto.Adapters.Postgres
end
