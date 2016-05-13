defmodule Table.Mixfile do
  use Mix.Project

  def package do
    [maintainers: ["Feng Zhou"],
     licenses: ["MIT"],
     description: "ascii tables for cli",
     links: %{"GitHub" => "https://github.com/zweifisch/table"}]
  end

  def project do
    [app: :table,
     version: "0.0.5",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package,
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    []
  end
end
