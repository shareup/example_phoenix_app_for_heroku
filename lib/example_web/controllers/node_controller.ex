defmodule ExampleWeb.NodeController do
  use ExampleWeb, :controller

  def index(conn, _params) do
    nodes =
      [Node.self() | Node.list()]
      |> Enum.sort()

    render(conn, "index.html", nodes: nodes)
  end
end
