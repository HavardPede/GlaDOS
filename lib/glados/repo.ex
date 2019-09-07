defmodule Glados.Repo do
  use Ecto.Repo,
    otp_app: :glados,
    adapter: Ecto.Adapters.Postgres
end
