defmodule StockMonitor.StockSupervisor do
  use DynamicSupervisor

  alias StockMonitor.Stock
  
  def start_link(arg) do
    DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
  
  def start_child({_, _, _, _, _} = state) do
    child_spec = {Stock, state} 
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

end
