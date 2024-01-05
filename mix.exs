defmodule TableauExt.MixProject do
  use Mix.Project

  def project do
    [
      app: :tableau_ext,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      # {:tableau, "~> 0.14"}
      # {:tableau, path: "~/zz/tableau"}
      {:tableau, github: "andyl/tableau", branch: "basepath_routing"},
    ]
  end
end
