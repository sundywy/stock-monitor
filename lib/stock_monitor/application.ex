defmodule StockMonitor.Application do
  use Application

  alias StockMonitor.{Server, StockSupervisor}
  
  def start(_type, _args) do
    children = [
      %{id: Server, start: {Server, :start_link, [self(), [url: "http://localhost:8080/stock"]]}},
      %{id: StockSupervisor, start: {StockSupervisor, :start_link, [:ok]}, strategy: :one_for_one},
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: __MODULE__)
  end

   
  def start_child_supervisor() do
    child_spec = [restart: :temporary, start: {StockSupervisor, :start_link, [:ok]}, type: :supervisor, strategy: :one_for_one]
    Supervisor.start_child(__MODULE__, child_spec)
  end
  
end
