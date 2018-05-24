defmodule StockMonitor.StockSupervisor do
  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg)
  end

  def init(_arg) do

    children = [
      StockMonitor.Stock,
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
  
  def start_child(pid, {_, _, _, _, _} = state) do
    Supervisor.start_child(pid, state)
  end

end
