defmodule StockMonitor.Stock do
  use GenServer

  alias __MODULE__
  
  @enforce_keys [:ticker_symbol, :trade_type, :price, :quantity, :id]
  defstruct [:ticker_symbol, :trade_type, :price, :quantity, :id]

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def check_stock(pid, other) do
    GenServer.call(pid, {:check_stock, other})
  end
  
  ## callback
  
  def init({ticker_symbol, trade_type, price, quantity, id}) do
    {:ok, %Stock{ticker_symbol: ticker_symbol, trade_type: trade_type, price: price, quantity: quantity, id: id}}
  end

  def handle_call({:check_stock, other}, _from, state) do
    case same_stock?(state, other) do
      true -> {:reply, self, state}
      false -> {:reply, :false, state}
    end
  end

  
  
  
  
end
