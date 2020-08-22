defmodule Fictitious.MixProject do
  use Mix.Project

  @version "0.2.0"

  def project do
    [
      app: :fictitious,
      version: @version,
      elixir: "~> 1.9",
      config_path: "./config/config.exs",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      aliases: aliases(),
      name: "Fictitious",
      source_url: "https://github.com/abiwinanda/fictitious",
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    if Mix.env() in [:test, :dev] do
      [
        mod: {Fictitious.Application, []},
        extra_applications: [:logger]
      ]
    else
      [
        extra_applications: [:logger]
      ]
    end
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 3.1"},
      {:ksuid, "~> 0.1.2"},
      {:misc_random, "~> 0.2.9"},
      {:ecto_sql, "~> 3.1", only: [:test, :dev]},
      {:postgrex, "~> 0.15.1", only: [:test, :dev]},
      {:ex_doc, "~> 0.22.0", only: [:test, :dev], runtime: false}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end

  defp description() do
    "Generate fictitious data in elixir for unit test."
  end

  defp package() do
    [
      # These are the default files included in the package
      maintainers: ["Nyoman Abiwinanda"],
      files: [
        "lib/fictitious.ex",
        "mix.exs",
        "LICENSE.md",
        "README.md",
        ".formatter.exs"
      ],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/abiwinanda/fictitious"}
    ]
  end

  defp docs do
    [
      main: Fictitious,
      extras: ["CHANGELOG.md"],
      source_ref: "v#{@version}",
      source_url: "https://github.com/abiwinanda/fictitious"
    ]
  end
end
