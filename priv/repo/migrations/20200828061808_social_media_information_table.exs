defmodule Fictitious.Repo.Migrations.CreateSocialMediaInformationTable do
  use Ecto.Migration

  def change do
    create unique_index(:persons, [:email], name: :email_unique_index)

    create table(:social_media_informations) do
      add :email, references(:persons, column: :email, type: :string, on_delete: :nothing)
      add :is_active, :boolean
      add :last_login, :date

      timestamps()
    end
  end
end
