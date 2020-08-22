defmodule Fictitious.Person do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Fictitious.{Country, Person}

  schema "persons" do
    field :name, :string
    field :age, :integer
    field :gender, :string
    field :email, :string
    belongs_to :nationality, Country, references: :id, foreign_key: :country_id, type: :id
    belongs_to :parent, Person, references: :id, foreign_key: :parent_id, type: :id

    timestamps()
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [:id, :name, :age, :email, :parent_id])
    |> validate_inclusion(:gender, ["MALE", "FEMALE"])
  end
end
