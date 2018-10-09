defmodule Example.TaskTest do
  use Example.DataCase
  import Example.Factory

  test "requires title" do
    valid_task =
      params_for(:task)
      |> Example.Task.changeset()

    invalid_task =
      params_for(:task, title: nil)
      |> Example.Task.changeset()

    assert {:ok, _} = Repo.insert(valid_task)
    assert {:error, _} = Repo.insert(invalid_task)
  end
end
