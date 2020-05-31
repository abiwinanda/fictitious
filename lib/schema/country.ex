defmodule Fictitious.Country do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Fictitious.Person

  schema "countries" do
    field :name, :string
    has_many :people, Person, foreign_key: :country_id

    timestamps()
  end

  @doc false
  def changeset(country, attrs) do
    country
    |> cast(attrs, [:id, :name, :age, :email])
  end
end
