defmodule Fictitious.Person do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Fictitious.{Country, Person, SocialMediaInformation}

  schema "persons" do
    field(:name, :string)
    field(:age, :integer)
    field(:gender, :string)
    field(:email, :string)
    belongs_to(:nationality, Country, references: :id, foreign_key: :country_id, type: :id)
    belongs_to(:parent, Person, references: :id, foreign_key: :parent_id, type: :id)

    has_one(:social_media_information, SocialMediaInformation, foreign_key: :email)

    timestamps()
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [:id, :name, :age, :email, :parent_id])
    |> validate_inclusion(:gender, ["MALE", "FEMALE"])
  end
end
