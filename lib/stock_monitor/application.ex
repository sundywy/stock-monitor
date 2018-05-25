defmodule StockMonitor.Application do
  use Application

  alias StockMonitor.{Server, StockSupervisor}
  
  def start(_type, _args) do
    children = [
      %{id: Server, start: {Server, :start_link, [self(), [url: "http://localhost:8080/stock"]]}},
      %{id: StockSupervisor, start: {StockSupervisor, :start_link, [:ok]}, strategy: :one_for_one},
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

   
  def start_child_supervisor(pid, child_spec) do
    Supervisor.start_child(pid, child_spec)
  end
end
