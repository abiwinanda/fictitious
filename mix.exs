defmodule Fictitious.MixProject do
  use Mix.Project

  def project do
    [
      app: :fictitious,
      version: "0.0.1",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "Fictitious",
      source_url: "https://github.com/abiwinanda/fictitious"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 3.1"},
      {:ksuid, "~> 0.1.2"},
      {:ecto_sql, "~> 3.1"},
      {:postgrex, "~> 0.15.1"},
      {:misc_random, "~> 0.2.9"},
      {:ex_doc, "~> 0.22.0", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "Generate fictitious data in elixir for unit test."
  end

  defp package() do
    [
      # These are the default files included in the package
      files: [
        "lib",
        "mix.exs",
        "README.md",
        ".formatter.exs"
      ],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/abiwinanda/fictitious"}
    ]
  end
end
