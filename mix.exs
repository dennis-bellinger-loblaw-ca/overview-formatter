defmodule OverviewFormatter.MixProject do
  use Mix.Project

  def project do
    [
      app: :overview_formatter,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      preferred_cli_env: ["test.overview": :test]
    ] ++ docs()
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
      {:ex_doc, "~> 0.32.1", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      name: "OverviewFormatter",
      docs: [
        main: "Mix.Tasks.Test.Overview",
        extras: ["README.md"]
      ]
    ]
  end
end
