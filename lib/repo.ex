defmodule Fictitious.Repo do
  @moduledoc false
  use Ecto.Repo,
    otp_app: :fictitious,
    adapter: Ecto.Adapters.Postgres
end
