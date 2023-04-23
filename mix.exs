defmodule TestIex.MixProject do
  use Mix.Project

  @github_url "https://github.com/maxohq/maxo_test_iex"
  @version "0.1.6"
  @description "Run ExUnit tests from IEx shell."

  def project do
    [
      app: :maxo_test_iex,
      source_url: @github_url,
      version: @version,
      description: @description,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(), 
      docs: [extras: ["README.md"]]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {TestIex.Application, []}
    ]
  end

  defp package do
    [
      files: ~w(lib mix.exs README* CHANGELOG*),
      licenses: ["MIT"],
      links: %{
        "Github" => @github_url,
        "Changelog" => "#{@github_url}/blob/main/CHANGELOG.md"
      }
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:bunt, "~> 0.2"},
      {:file_system, "~> 0.2"},
      {:ex_doc, "~> 0.29", only: :dev, runtime: false},
      {:mneme, "0.3.1", only: [:dev, :test]}
    ]
  end
end
