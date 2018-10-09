defmodule Example.Factory do
  use ExMachina.Ecto, repo: Example.Repo

  def task_factory do
    %Example.Task{
      title: "Hello world",
      notes: ""
    }
  end
end
