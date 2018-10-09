defmodule Example.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field(:title, :string)
    field(:notes, :string, default: "")
    timestamps()
  end

  def changeset(params \\ %{}) do
    %__MODULE__{}
    |> cast(params, [:title, :notes])
    |> validate_required([:title])
    |> validate_length(:title, max: 1024)
  end
end
