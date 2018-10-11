defmodule Example.NodeMonitor do
  require Logger
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def refresh do
    GenServer.call(__MODULE__, :refresh)
  end

  @impl true
  def init(_) do
    :net_kernel.monitor_nodes(true)
    {:ok, all_nodes()}
  end

  @impl true
  def handle_call(:refresh, _from, state) do
    {:reply, MapSet.to_list(state), state}
  end

  @impl true
  def handle_info({:nodeup, node}, state) do
    Logger.debug("nodeup #{node}")
    state = MapSet.put(state, node)
    broadcast(state)
    {:noreply, state}
  end

  def handle_info({:nodedown, node}, state) do
    Logger.debug("nodedown #{node}")

    # The order of down and up is not guarunteed, so I ping the node to see if
    # it's still alive because it might have just been intermittent.

    case Node.ping(node) do
      :pong ->
        Logger.debug(":pong #{node}")
        {:noreply, state}

      :pang ->
        Logger.debug(":pang #{node}")
        state = MapSet.delete(state, node)
        broadcast(state)
        {:noreply, state}
    end
  end

  defp broadcast(state),
    do:
      ExampleWeb.Endpoint.broadcast("nodes:all", "refresh", %{
        me: Node.self(),
        nodes: MapSet.to_list(state)
      })

  defp all_nodes do
    Node.list() |> MapSet.new()
  end
end
