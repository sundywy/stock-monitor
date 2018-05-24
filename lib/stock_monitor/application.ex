defmodule StockMonitor.Application do
  use Application

  def start(_type, _args) do
    children = [
      StockMonitor.Server,
      StockMonitor.StockSupervisor
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def start_child_supervisor(pid, child_spec) do
    Supervisor.start_child(pid, child_spec)
  end
end
