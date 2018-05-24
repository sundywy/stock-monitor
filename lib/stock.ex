defmodule StockMonitor.Stock do
  use Agent
  
  alias __MODULE__

  defmodule StockData do
    defstruct [:ticker_symbol, :trade_type, :price, :quantity, :id]
  end
  
  def start_link({ticker_symbol, trade_type, price, quantity, id} = stock_data) do
    stock = %StockData{ticker_symbol: ticker_symbol, trade_type: trade_type, price: price, quantity: quantity, id: id}
    # GenServer.start_link(__MODULE__, [stock])

    Agent.start_link(fn -> stock end)
  end

  def get(pid) do
    Agent.get(pid, fn x -> x end)
  end
  
  def stop(pid) do
    Agent.stop(pid)
  end

end
