defmodule Whisk.MixProject do
  use Mix.Project

  def project do
    [
      app: :whisk,
      version: "0.0.3",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "Whisk",
      source_url: "https://github.com/gcpreston/whisk",
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.24", only: :dev, runtime: false}
    ]
  end

  defp description do
    "A twisty puzzle scramble generator."
  end

  defp package do
    [
      files: ~w(lib .formatter.exs mix.exs README.md LICENSE.md),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/gcpreston/whisk"}
    ]
  end

  defp docs do
    [
      extras: ["README.md"],
      main: "readme"
    ]
  end
end
