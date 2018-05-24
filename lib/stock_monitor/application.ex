defmodule StockMonitor.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised

    pool_config = []
    
    children = [
      worker(StockMonitor.Server, [self, pool_config])
    ]

    opts = [strategy: :one_for_all]

    supervise(children, opts)
  end
end
