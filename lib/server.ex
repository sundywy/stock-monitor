defmodule StockMonitor.Server do
  use GenServer
  import Supervisor.Spec

  alias StockMonitor.StockSupervisor
    
  defmodule State do
    defstruct sup: nil, stock_supervisor: nil, stock_worker: nil, url: nil
  end
  
  def start_link(sup, pool_config) do
    GenServer.start_link(__MODULE__, [sup, pool_config], name: __MODULE__)
  end

  def start_application do
    GenServer.cast(__MODULE__, {:start_application})
  end
  
  def start_child({_, _, _, _, _} = stock_data) do
    GenServer.call(__MODULE__, {:start_child, stock_data})
  end
    
  def init([sup, pool_config]) when is_pid(sup) do
    init(pool_config, %State{sup: sup, stock_worker: []})
  end

  def init({[:url, url | rest]}, state) do
    init(rest, %{state | url: url})
  end
  

  def init([], state) do
    send(self, :start_stock_supervisor)
    {:ok, state}
  end

  def handle_cast({:start_application}, state) do
    get_stock(state.url)
  end
  
  def handle_call({:start_child, {_, _, _, _, _} = stock_data}, _from, state) do
    {:ok, child_pid} = StockSupervisor.start_child(stock_data)
    stock_worker = [child_pid | state.stock_worker]
    {:reply, child_pid, %{state | stock_worker: stock_worker}}
  end
  
  def handle_info(:start_stock_supervisor, state) do
    {:ok, stock_supervisor} = Supervisor.start_child(state.sup, supervisor_spec(state.mfa))
    new_state = %{state | stock_supervisor: stock_supervisor}
    {:noreply, new_state}
  end

  defp supervisor_spec(mfa) do
    opts = [restart: :temporary]
    supervisor(StockMonitor.StockSupervisor, [mfa], opts)
  end

  def test_get_stock({ticker_symbol, trade_type, price, quantity, id} = stock_data) do
    start_child(stock_data)
  end
  
  defp get_stock(url) do
    result = url
    |> HTTPoison.get
    |> parse_response

    case result do
      {:ok, stock_data} ->
        {:ok, child} = start_child(stock_data)
        {:noreply, :success, "#{child} started with #{stock_data}"}
      :error ->
        {:noreply, "Error in getting stock"}
    end
  end
  
  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    json = body |> JSON.decode!
    {:ok, {json.ticker_symbol, json.trade_type, json.price, json.quantity, json.id}}
  end

  defp parse_response(_) do
    :error
  end
  
end
