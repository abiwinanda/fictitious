defmodule Fictitious.SocialMediaInformation do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Fictitious.Person

  schema "social_media_informations" do
    field :is_active, :boolean
    field :last_login, :date

    belongs_to :user, Person, references: :email, foreign_key: :email, type: :string

    timestamps()
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [:id, :email, :is_active, :last_login])
  end
end
