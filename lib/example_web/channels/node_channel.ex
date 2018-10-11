defmodule ExampleWeb.NodeChannel do
  use Phoenix.Channel

  def join("nodes:all", _message, socket) do
    socket = assign(socket, :me, Node.self())
    nodes = Example.NodeMonitor.refresh()
    {:ok, %{nodes: nodes, me: socket.assigns.me}, socket}
  end

  def handle_in("refresh", _, socket) do
    nodes = Example.NodeMonitor.refresh()
    {:reply, {:ok, %{nodes: nodes, me: socket.assigns.me}}, socket}
  end
end
