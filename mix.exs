defmodule Whisk.MixProject do
  use Mix.Project

  def project do
    [
      app: :whisk,
      version: "0.0.1",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "Whisk",
      source_url: "https://github.com/gcpreston/whisk",
      docs: [
        main: "Whisk",
        extras: ["README.md"]
      ]
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
end
