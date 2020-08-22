defmodule Fictitious.Repo.Migrations.AddParentFieldInPerson do
  use Ecto.Migration

  def change do
    alter table(:persons) do
      add :parent_id, references(:persons, column: :id, type: :id, on_delete: :nothing)
    end
  end
end
