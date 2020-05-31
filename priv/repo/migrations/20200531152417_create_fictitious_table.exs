defmodule Fictitious.Repo.Migrations.CreateFictitiousTable do
  use Ecto.Migration

  def change do
    create table(:countries) do
      add :name, :string

      timestamps()
    end

    create table(:persons) do
      add :name, :string
      add :age, :integer
      add :gender, :string
      add :email, :string
      add :country_id, references(:countries, column: :id, type: :id, on_delete: :nothing)

      timestamps()
    end
  end
end
