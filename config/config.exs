import Config

config :fictitious, :children, []

import_config "#{Mix.env()}.exs"
