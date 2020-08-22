import Config

# Print only warnings and errors during test
config :logger, level: :warn

config :fictitious,
  ecto_repos: [Fictitious.Repo]

config :fictitious, Fictitious.Repo,
  username: System.get_env("FICTITIOUS_USERNAME_TEST"),
  password: System.get_env("FICTITIOUS_PASSWORD_TEST"),
  database: System.get_env("FICTITIOUS_DATABASE_TEST"),
  hostname: System.get_env("FICTITIOUS_HOSTNAME_TEST"),
  port: System.get_env("FICTITIOUS_PORT_TEST", "5432"),
  pool: Ecto.Adapters.SQL.Sandbox

config :fictitious, :repo,
  default: Fictitious.Repo,
  second_repo: Fictitious.Repo
