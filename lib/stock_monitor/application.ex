defmodule StockMonitor.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  
  use Supervisor
  use Application

  def start(_type, _args) do
    # List all child processes to be supervised

    # pool_config = [url: "http://localhost:8080"]
    
    children = [
      StockMonitor.Server
      # StockMonitor.StockSupervisor
    ]

    opts = [strategy: :one_for_all]
    
    Supervisor.init(children, opts)
  end

  def start_stock_supervisor do
    
  end
  
end
