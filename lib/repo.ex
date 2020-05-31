defmodule Fictitious.Repo do
  use Ecto.Repo,
    otp_app: :fictitious,
    adapter: Ecto.Adapters.Postgres
end
