import Config

config :fictitious,
  ecto_repos: [Fictitious.Repo]

config :fictitious, Fictitious.Repo,
  username: System.get_env("FICTITIOUS_USERNAME", "postgres"),
  password: System.get_env("FICTITIOUS_PASSWORD", "postgres"),
  database: System.get_env("FICTITIOUS_DATABASE", "fictitious"),
  hostname: System.get_env("FICTITIOUS_HOSTNAME", "localhost"),
  port: System.get_env("FICTITIOUS_PORT", "5432")

config :fictitious, :repo, default: Fictitious.Repo
