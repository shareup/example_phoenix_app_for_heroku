defmodule Example.Repo.Migrations.AddTasksTable do
  use Ecto.Migration

  def change do
    create table("tasks") do
      add(:title, :string, size: 1024, null: false)
      add(:notes, :text, default: "", null: false)
      timestamps()
    end
  end
end
