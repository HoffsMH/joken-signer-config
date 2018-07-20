defmodule Joken.Signer.Config.MixProject do
  use Mix.Project

  @version "0.1.0"

  def description do
    "A simple configuration plugin for Joken Signers"
  end

  def project do
    [
      app: :joken_signer_config,
      version: @version,
      elixir: "~> 1.6",
      description: description(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: docs_config()
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
      {:joken, "~> 1.5.0"},
      {:poison, "~> 3.1.0"},
      {:ex_doc, ">= 0.18.4", only: :dev},
      {:dialyxir, "~> 1.0.0-rc.2", only: [:dev], runtime: false}
    ]
  end

  def package do
    [
      files: ~w(lib mix.exs),
      maintainers: ["Matt Hecker"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/HoffsMH/joken-signer-config"}
    ]
  end

  defp docs_config do
    [extras: ["README.md": [title: "Overview", path: "overview"]],
     main: "overview",
     source_ref: "v#{@version}",
     source_url: "https://github.com/HoffsMH/joken-signer-config"]
  end
end
