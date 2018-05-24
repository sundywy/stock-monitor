defmodule StockMonitor.MixProject do
  use Mix.Project

  def project do
    [
      app: :stock_monitor,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:httpoison, :json],
      mod: {StockMonitor.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.1.0"},
      {:json, "~> 1.2.0"}
    ]
  end
end
