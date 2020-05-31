import Config

config :fictitious, :children, [Fictitious.Repo]

config :fictitious,
  ecto_repos: [Fictitious.Repo]

config :fictitious, Fictitious.Repo,
  username: System.get_env("FICTITIOUS_USERNAME_TEST"),
  password: System.get_env("FICTITIOUS_PASSWORD_TEST"),
  database: System.get_env("FICTITIOUS_DATABASE_TEST"),
  hostname: System.get_env("FICTITIOUS_HOSTNAME_TEST"),
  pool: Ecto.Adapters.SQL.Sandbox

config :fictitious, :repo,
  default: Fictitious.Repo,
  second_repo: Fictitious.Repo
