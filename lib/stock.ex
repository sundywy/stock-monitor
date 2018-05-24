defmodule StockMonitor.Stock do
  use GenServer

  alias __MODULE__

  defmodule StockData do
    defstruct [:ticker_symbol, :trade_type, :price, :quantity, :id]
  end
  
  def start_link({_, _, _, _, _} = stock_data) do
    GenServer.start_link(__MODULE__, :ok, stock_data)
  end

  def stop(pid) do
    GenServer.call(pid, :stop)
  end
  
  ## callback
  
  def init({ticker_symbol, trade_type, price, quantity, id}) do
    {:ok, %StockData{ticker_symbol: ticker_symbol, trade_type: trade_type, price: price, quantity: quantity, id: id}}
  end

end
