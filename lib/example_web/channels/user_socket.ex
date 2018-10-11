defmodule ExampleWeb.UserSocket do
  use Phoenix.Socket

  channel("nodes:*", ExampleWeb.NodeChannel)

  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
