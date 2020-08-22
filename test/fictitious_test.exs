defmodule FictitiousTest do
  use ExUnit.Case, async: true
  alias Fictitious.{Country, Person}

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Fictitious.Repo)
  end

  test "Fictitious does not generate the same data." do
    fictitious_countries =
      0..99
      |> Enum.reduce([], fn _, acc ->
        {:ok, country} = Fictitious.fictionize(Country)
        country = Map.from_struct(country)
        acc ++ [country]
      end)
      |> Enum.uniq_by(fn country -> country.id end)

    assert length(fictitious_countries) == 100
  end

  test "Fictitious can overwrite the specified field." do
    {:ok, country} = Fictitious.fictionize(Country, name: "Indonesia")
    assert country.name == "Indonesia"
  end

  test "Fictitious does generate the belongs_to associations." do
    {:ok, person} = Fictitious.fictionize(Person)
    person = Fictitious.Repo.preload(person, :nationality)
    assert not is_nil(person.nationality)
  end

  test "Fictitious can overwrite the specified belongs to field by passing an id." do
    {:ok, country} = Fictitious.fictionize(Country, name: "Indonesia")
    {:ok, person} = Fictitious.fictionize(Person, country_id: country.id)
    person = Fictitious.Repo.preload(person, :nationality)
    assert person.nationality.id == country.id
  end

  test "Fictitious can overwrite the specified belongs to field by passing the belons to entity." do
    {:ok, country} = Fictitious.fictionize(Country, name: "Indonesia")
    {:ok, person} = Fictitious.fictionize(Person, nationality: country)
    person = Fictitious.Repo.preload(person, :nationality)
    assert person.nationality.id == country.id
  end

  test "Fictitious can be configured to use more than one repo." do
    {:ok, country_1} = Fictitious.fictionize(Country, :second_repo)
    {:ok, country_2} = Fictitious.fictionize(Country, :second_repo, name: "Indonesia")
    assert not is_nil(country_1)
    assert country_2.name == "Indonesia"
  end

  test "Fictitious can overwrite the specified field by passing the parent struct. Testing with the same parent struct." do
    {:ok, country} = Fictitious.fictionize(Country, name: "Indonesia")
    {:ok, parent} = Fictitious.fictionize(Person, name: "John", nationality: country)

    {:ok, child} =
      Fictitious.fictionize(Person, name: "Marry", nationality: country, parent: parent)

    parent = Fictitious.Repo.preload(parent, [:nationality])
    child = Fictitious.Repo.preload(child, [:parent, :nationality])
    assert parent.nationality.id == country.id
    assert child.nationality.id == country.id
    assert parent.id == child.parent.id
  end

  test "Fictitious does not generate two records to a self referencing schema when overriding some fields." do
    {:ok, person} = Fictitious.fictionize(Person, name: "Poli")
    assert length(Fictitious.Repo.all(Person)) == 1
  end

  test "Fictitious can give null value to an independent field." do
    {:ok, person} = Fictitious.fictionize(Person, name: :null)
    assert is_nil(person.name)
  end

  # test "Fictitious can give null value to a belongs to association field key." do
  #   {:ok, person} = Fictitious.fictionize(Person, parent_id: :null)
  #   assert is_nil(person.parent_id)
  # end
end
