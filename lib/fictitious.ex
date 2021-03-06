defmodule Fictitious do
  @moduledoc """
  `Fictitious` is a tool that enables you to create a fictitious data in elixir. It helps you to create mock data for your unit test
  without having the hassle of preparing the data in an convoluted order according to their associations that they have. `Fictitious`
  will ensure that whatever ecto schema that is specified, you will get the schema created for you.

  ## Installation

  `Fictitious` only generates fictitious data hence it is recommended that you install them in test environment
  only but feel free to play around with `Fictitious` by having it installed in normal dev environment.
  Inside your `mix.exs` file add `{:fictitious, "~> 0.2.0", only: :test}` as one of your dependency:

      defp deps do
        [
          ...
          {:fictitious, "~> 0.2.0", only: :test},
          ...
        ]
      end

  Once you have it installed, you need to configure the `Fictitious` repo by adding the following configuration
  to your `test.exs` file:

      config :fictitious, :repo,
        default: YourApp.Repo

  Notice we put it inside `test.exs` file. This is because `Fictitious` is created to help you create mock data for
  your unit test hence most of the time you will definitely put this configuration in test environment only.

  In case your application has more than one `Repo` it is possible to configure multiple repos. In fact, you could configure as many as you want.
  To do so you could add more repos into the fictitious `:repo` configs as follow:

      config :fictitious, :repo,
        default: YourApp.Repo,
        second_repo: YourApp.SecondRepo,
        third_repo: YourApp.ThirdRepo

  The `default` repo will be used by default by `Fictitious` and it is mandatory to be specified.

  ## How to Use

  ### Basics

  Given you have the following ecto schema inside your app:

      defmodule YourApp.Schema.Person do
        use Ecto.Schema
        import Ecto.Changeset

        schema "persons" do
          field :name, :string
          field :age, :integer
          field :email, :string

          timestamps()
        end

        ...
      end

  To generate fictitious data of a person you could simply call `fictionize/1` function as follow:

      iex> Fictitious.fictionize(YourApp.Schema.Person)
      {:ok, %YourApp.Schema.Person{
        __meta__: #Ecto.Schema.Metadata<:loaded, "persons">,
        id: 35,
        name: "2cBfxcqnB0B5iqhYvK83RamaDa8KM0PvPpT1kVao",
        age: 514,
        email: "2cBfxcqnB0B5iqhYvK83RamaDa8KM0PvPpT1kVao",
        inserted_at: ~U[2020-04-31 06:19:27Z],
        updated_at: ~U[2020-04-31 06:19:27Z]
      }}

  `fictionize/1` will simply generate fictitious value according to its field's type. The currently supported
  primitive types by `Fictitious` can be found in [official ecto documentation](https://hexdocs.pm/ecto/Ecto.Schema.html#module-primitive-types).

  In case you want some fields to be specified manually, you could overwrite the values that are generated by `Fictitious` by providing the second argument:

      iex> Fictitious.fictionize(YourApp.Schema.Person, name: "some name", email: "some email")
      {:ok, %YourApp.Schema.Person{
        __meta__: #Ecto.Schema.Metadata<:loaded, "persons">,
        id: 652,
        name: "some name",
        age: 1241,
        email: "some email",
        inserted_at: ~U[2020-05-31 20:11:21Z],
        updated_at: ~U[2020-05-31 20:11:42Z]
      }}

  ### Schema with Changeset Validations

  The previous schema in `Basics` section was a simple schema where all fields only contain a primitive type.
  What happen if we now decided to modify the `persons` schema to add some field value validations in the `changeset/2` function as follow:

      defmodule YourApp.Schema.Person do
        use Ecto.Schema
        import Ecto.Changeset

        schema "persons" do
          field :name, :string
          field :age, :integer
          field :gender, :string
          field :email, :string

          timestamps()
        end

        @doc false
        def changeset(person, attrs) do
          person
          |> cast(attrs, [...])
          |> validate_inclusion(:gender, ["MALE", "FEMALE"]) # check if :gender is either "MALE" or "FEMALE"
          |> validate_email_format() # custom function to check if :email has the correct email format
        end
      end

  `Fictitious` will ignore any kind of validation in the changeset. Performing `fictionize/1` function to the new `persons`
  schema will still give you a fictitious value for `:gender` and `:email`:

      iex> Fictitious.fictionize(YourApp.Schema.Person)
      {:ok, %YourApp.Schema.Person{
        __meta__: #Ecto.Schema.Metadata<:loaded, "persons">,
        id: 1243,
        name: "2cBfxcqnB0B5iqhYvK83RamaDa8KM0PvPpT1kVao",
        age: 632,
        gender: "7U01hkeHYLLtSVNI3SPaSNSXrACVBsDRwFe13n6l7GzaAakcPkMtODZ2eiioqJHrWXITSLPMu7wJ8"
        email: "ixV5neQzcap5hq4dXycbt6Mj2fqgPLI3se6qXQbkmHOdoICyaX6",
        inserted_at: ~U[2020-04-31 06:19:27Z],
        updated_at: ~U[2020-04-31 06:19:27Z]
      }}

  In case you want the data to have the correct value for `:gender` and `:email` you need to specify them manually as previously has shown:

      iex> Fictitious.fictionize(YourApp.Schema.Person, gender: "MALE", email: "email@domain.com")
      {:ok, %YourApp.Schema.Person{
        __meta__: #Ecto.Schema.Metadata<:loaded, "persons">,
        id: 564545,
        name: "xIzommg1lpwgRNBQCcGXLXdxORM7gXGqVIkC3gDL2As1DhxmhdejE0tXR2ImlrXN7j72nDO3Y",
        age: 235111,
        gender: "MALE"
        email: "email@domain.com",
        inserted_at: ~U[2020-04-31 06:19:27Z],
        updated_at: ~U[2020-04-31 06:19:27Z]
      }}

  ### Associations

  The true comfort of `Fictitious` comes when you encounter ecto schemas that have `%Ecto.Association.BelongsTo{}` relations to other schemas. Given
  you have the following new `countries` schema as follow:

      defmodule YourApp.Schema.Country do
        use Ecto.Schema
        import Ecto.Changeset
        alias YourApp.Schema.Person

        schema "countries" do
          field :name, :string
          has_many :people, Person, foreign_key: :country_id

          timestamps()
        end

        ...
      end

  and in a `persons` schema we add `belongs_to` relation to `countries` as follow:

      defmodule YourApp.Schema.Person do
        use Ecto.Schema
        import Ecto.Changeset
        alias YourApp.Schema.Country

        schema "persons" do
          field :name, :string
          field :age, :integer
          field :gender, :string
          field :email, :string
          belongs_to :nationality, Country, references: :id, foreign_key: :country_id, type: :id  # Added belongs_to relation

          timestamps()
        end
      end

  then depending on how you set the tables' relation in the DB, it is usually meant that for a person to exist it must belongs to a country hence
  before any person record could be created, you must at least has one country record. It is possible that a person could exist without a country if
  no constraint exist in the DB however this is the assumption that `Fictitous` will always make whenenver a schema has an `%Ecto.Association.BelongsTo{}`
  relation. It will always assume that since `persons` belongs to `countries` then a country record must exist first.

  calling `fictionize/1` to `YourApp.Schema.Country` will only makes a fictitious country:

      iex> Fictitious.fictionize(YourApp.Schema.Country)
      {:ok, %YourApp.Schema.Country{
        __meta__: #Ecto.Schema.Metadata<:loaded, "countries">,
        id: 67,
        name: "B8LemwxB8ULP4NLUaFnKfwWkMmBYy8BTytkSN2PiL1UTO47yRM",
        people: #Ecto.Association.NotLoaded<association :people is not loaded>,
        inserted_at: ~U[2020-04-31 06:19:27Z],
        updated_at: ~U[2020-04-31 06:19:27Z]
      }}

  however calling `fictionize/1` to `YourApp.Schema.Person` will creates a person by creating the country first:

      iex> {:ok, person} = Fictitious.fictionize(YourApp.Schema.Person)
      {:ok, %YourApp.Schema.Person{
        __meta__: #Ecto.Schema.Metadata<:loaded, "persons">,
        id: 725,
        name: "bElHKj9zVwnkLRpO4Y23yon9n80gm1yeAEL4PgtgkxBc0p2Y7C",
        age: 364,
        gender: "dF1O5Eq4ombjzah",
        email: "hpOXdOriGA9xaMhnwese40PqqL2Ine",
        nationality: #Ecto.Association.NotLoaded<association :nationality is not loaded>,
        nationality_id: 401,
        inserted_at: ~U[2020-04-31 06:19:27Z],
        updated_at: ~U[2020-04-31 06:19:27Z]
      }}

      iex> YourApp.Repo.preload(person, :nationality)
      %YourApp.Schema.Person{
        __meta__: #Ecto.Schema.Metadata<:loaded, "persons">,
        id: 725,
        name: "bElHKj9zVwnkLRpO4Y23yon9n80gm1yeAEL4PgtgkxBc0p2Y7C",
        age: 364,
        gender: "dF1O5Eq4ombjzah",
        email: "hpOXdOriGA9xaMhnwese40PqqL2Ine",
        nationality: %YourApp.Schema.Country{
          __meta__: #Ecto.Schema.Metadata<:loaded, "countries">,
          id: 401,
          name: "lcb1e86TY6RSccL6vPGjXOv43gnp1t",
          people: #Ecto.Association.NotLoaded<association :people is not loaded>
          inserted_at: ~U[2020-04-31 06:19:27Z],
          updated_at: ~U[2020-04-31 06:19:27Z]
        },
        nationality_id: 401,
        inserted_at: ~U[2020-04-31 06:19:27Z],
        updated_at: ~U[2020-04-31 06:19:27Z]
      }

  Having the `belongs_to` associations to be created automatically removes the trouble of having to prepare other entities before
  we could create the wanted entity. This is usually happens a lot of time during preparing unit test data hence this is one problem
  that `Fictitious` could solve and save us a lot of time. `Fictitious` ensures that you get the targeted or wanted entity to be created.

  In case you want the created fictitious person to belongs to the previously created fictitious country then there are two ways you
  could do that. First is by manually changing the `:country_id` as follows:

      iex> {:ok, country} = Fictitious.fictionize(YourApp.Schema.Country, name: "Indonesia")
      {:ok, %YourApp.Schema.Country{
        __meta__: #Ecto.Schema.Metadata<:loaded, "countries">,
        id: 666409,
        name: "Indonesia",
        people: #Ecto.Association.NotLoaded<association :people is not loaded>,
        inserted_at: ~U[2020-04-31 06:19:27Z],
        updated_at: ~U[2020-04-31 06:19:27Z]
      }}

      iex> {:ok, person} = Fictitious.fictionize(YourApp.Schema.Person, country_id: country.id)
      {:ok, %YourApp.Schema.Person{
        __meta__: #Ecto.Schema.Metadata<:loaded, "persons">,
        id: 5230,
        name: "FZcb5Q4zLOO4aMrdi1RblsEPpushgAn9zoPtfMbJWlsNe",
        age: 5768,
        gender: "FBTG2Ls4Fi9nD6oazpPjBqti5DfdmqyGTaQp5xlxjiH9B",
        email: "cgOACnmDFqbO5NxEZ0AUtwtjEfZBMcv3QzAq3esrcJHo7",
        nationality: #Ecto.Association.NotLoaded<association :nationality is not loaded>,
        inserted_at: ~U[2020-04-31 06:19:27Z],
        updated_at: ~U[2020-04-31 06:19:27Z]
      }}

  or second, by passing the whole `%YourApp.Schema.Country{}` struct as follows:

      iex> {:ok, country} = Fictitious.fictionize(YourApp.Schema.Country, name: "Indonesia")
      {:ok, %YourApp.Schema.Country{
        __meta__: #Ecto.Schema.Metadata<:loaded, "countries">,
        id: 7914,
        name: "Indonesia",
        people: #Ecto.Association.NotLoaded<association :people is not loaded>,
        inserted_at: ~U[2020-04-31 06:19:27Z],
        updated_at: ~U[2020-04-31 06:19:27Z]
      }}

      iex> {:ok, person} = Fictitious.fictionize(YourApp.Schema.Person, nationality: country)
      {:ok, %YourApp.Schema.Person{
        __meta__: #Ecto.Schema.Metadata<:loaded, "persons">,
        id: 451,
        name: "ZFvtidsGOPh6OymYJk529bL2QT9KMZic2A0ietddl2RWy",
        age: 150940,
        gender: "rHZYpbDgJQokDX2vSpSfWUmELrTb9f",
        email: "xmcuHrJvotjAQz6itQnZtoMp",
        nationality: #Ecto.Association.NotLoaded<association :nationality is not loaded>,
        inserted_at: ~U[2020-04-31 06:19:27Z],
        updated_at: ~U[2020-04-31 06:19:27Z]
      }}

  ### Self-referencing Schema

  Given we edit the `persons` schema to self-reference to itself as follows:

      defmodule YourApp.Schema.Person do
        use Ecto.Schema
        import Ecto.Changeset
        alias YourApp.Schema.Person
        alias YourApp.Schema.Country

        schema "persons" do
          field :name, :string
          field :age, :integer
          field :gender, :string
          field :email, :string
          belongs_to :parent, Person, references: :id, foreign_key: :parent_id, type: :id # Self-reference to itself
          belongs_to :nationality, Country, references: :id, foreign_key: :country_id, type: :id

          timestamps()
        end
      end

  then calling `fictionize/1` to `YourApp.Schema.Person` will not create the self-reference schema:

      iex> {:ok, person} = Fictitious.fictionize(YourApp.Schema.Person)
      {:ok, %YourApp.Schema.Person{
        __meta__: #Ecto.Schema.Metadata<:loaded, "persons">,
        id: 725,
        name: "bElHKj9zVwnkLRpO4Y23yon9n80gm1yeAEL4PgtgkxBc0p2Y7C",
        age: 364,
        gender: "dF1O5Eq4ombjzah",
        email: "hpOXdOriGA9xaMhnwese40PqqL2Ine",
        parent: #Ecto.Association.NotLoaded<association :parent is not loaded>,
        parent_id: nil,
        nationality: #Ecto.Association.NotLoaded<association :nationality is not loaded>,
        nationality_id: 131421,
        inserted_at: ~U[2020-04-31 06:19:27Z],
        updated_at: ~U[2020-04-31 06:19:27Z]
      }}

  This is done so that `Fictitious` does not trapped in an infinite loop when creating a self-referencing schema.

  ### Giving Null Value

  By default `Fictitious` will always generate a fictitious values to all fields in an ecto schema.
  If you want certain fields to be `nil` or null you could give `:null` as the value as follows:

      iex> {:ok, person} = Fictitious.fictionize(YourApp.Schema.Person, name: :null)
      {:ok, %YourApp.Schema.Person{
        __meta__: #Ecto.Schema.Metadata<:loaded, "persons">,
        id: 725,
        name: nil,
        age: 54245,
        gender: "aF1F5Eq4ambquih",
        email: "hpOXdOriGA9xaMhnwese40PqqL2Ine",
        parent: #Ecto.Association.NotLoaded<association :parent is not loaded>,
        parent_id: nil,
        nationality: #Ecto.Association.NotLoaded<association :nationality is not loaded>,
        nationality_id: 531,
        inserted_at: ~U[2020-07-22 11:38:27Z],
        updated_at: ~U[2020-07-22 11:38:27Z]
      }}

  ### Multiple Repos

  Given you configured the `Fictitious` repo as follow:

      config :fictitious, :repo,
        default: YourApp.Repo,
        second_repo: YourApp.SecondRepo

  then to use the second repo you could use `fictionize/2` or `fictionize/3` as follows:

      iex> Fictitious.fictionize(YourApp.Schema.Continent, :second_repo)
      iex> Fictitious.fictionize(YourApp.Schema.Continent, :second_repo, name: "overwrite name")
  """
  import Ecto.Changeset

  defp repo(opts) do
    case opts do
      :default -> Application.get_env(:fictitious, :repo)[:default]
      _ -> Application.get_env(:fictitious, :repo)[opts]
    end
  end

  def fictionize(%Ecto.Association.BelongsTo{
        related: belongs_to_ecto_schema,
        owner: owner_ecto_schema
      }) do
    case owner_ecto_schema == belongs_to_ecto_schema do
      true -> {:ok, %{}}
      false -> fictionize(belongs_to_ecto_schema)
    end
  end

  @spec fictionize(Ecto.Schema.t()) ::
          {:ok, %{} | Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def fictionize(ecto_schema) do
    ecto_schema
    |> fictitious_changeset(
      Map.merge(
        fictionize_independent_fields(ecto_schema),
        fictionize_belongs_to_association_fields(ecto_schema)
      )
    )
    |> repo(:default).insert()
    |> case do
      {:ok, data} -> {:ok, data}
      {:error, error} -> {:error, error}
    end
  end

  def fictionize(
        %Ecto.Association.BelongsTo{
          related: belongs_to_ecto_schema,
          owner: owner_ecto_schema
        },
        repo
      )
      when is_atom(repo) and not is_nil(repo) do
    case owner_ecto_schema == belongs_to_ecto_schema do
      true -> {:ok, %{}}
      false -> fictionize(belongs_to_ecto_schema)
    end
  end

  @spec fictionize(Ecto.Schema.t(), nil | Atom.t() | Keyword.t()) ::
          {:ok, %{} | Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def fictionize(ecto_schema, repo) when is_atom(repo) and not is_nil(repo) do
    ecto_schema
    |> fictitious_changeset(
      Map.merge(
        fictionize_independent_fields(ecto_schema),
        fictionize_belongs_to_association_fields(ecto_schema, repo)
      )
    )
    |> repo(repo).insert()
    |> case do
      {:ok, data} -> {:ok, data}
      {:error, error} -> {:error, error}
    end
  end

  def fictionize(
        %Ecto.Association.BelongsTo{
          related: belongs_to_ecto_schema,
          owner: owner_ecto_schema
        },
        opts
      ) do
    cond do
      owner_ecto_schema == belongs_to_ecto_schema -> {:ok, %{}}
      is_nil(opts) -> fictionize(belongs_to_ecto_schema)
      is_list(opts) -> fictionize(belongs_to_ecto_schema, opts)
    end
  end

  def fictionize(ecto_schema, opts) do
    ecto_schema
    |> fictitious_changeset(
      Map.merge(
        fictionize_independent_fields(ecto_schema, opts),
        fictionize_belongs_to_association_fields(ecto_schema, opts)
      )
    )
    |> repo(:default).insert()
    |> case do
      {:ok, data} -> {:ok, data}
      {:error, error} -> {:error, error}
    end
  end

  def fictionize(
        %Ecto.Association.BelongsTo{
          related: belongs_to_ecto_schema,
          owner: owner_ecto_schema
        },
        repo,
        opts
      )
      when is_atom(repo) do
    cond do
      owner_ecto_schema == belongs_to_ecto_schema -> {:ok, %{}}
      is_nil(opts) -> fictionize(belongs_to_ecto_schema, repo)
      is_list(opts) -> fictionize(belongs_to_ecto_schema, repo, opts)
    end
  end

  @spec fictionize(Ecto.Schema.t(), Atom.t(), nil | Keyword.t()) ::
          {:ok, %{} | Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def fictionize(ecto_schema, repo, opts) when is_atom(repo) do
    ecto_schema
    |> fictitious_changeset(
      Map.merge(
        fictionize_independent_fields(ecto_schema, opts),
        fictionize_belongs_to_association_fields(ecto_schema, repo, opts)
      )
    )
    |> repo(repo).insert()
    |> case do
      {:ok, data} -> {:ok, data}
      {:error, error} -> {:error, error}
    end
  end

  ###################################
  #           FICTIONIZER           #
  ###################################

  defp fictitious_changeset(ecto_schema, attrs) do
    cast(ecto_schema.__struct__, attrs, get_fields(ecto_schema))
  end

  # Fictionize a single independent field of an ecto schema
  #
  # Examples:
  #
  #   iex> fictionize_independent_field(Person, :name)
  #   "zfIXmoU1dkAkZ4Ne2Us2rwi"
  #
  #   iex> fictionize_independent_field(Person, :age)
  #   70912142
  #
  defp fictionize_independent_field(ecto_schema, field) do
    ecto_schema
    |> get_field_type(field)
    |> gen_random()
  end

  # Fictionize all independent fields of an ecto schema
  #
  # Examples:
  #
  #   iex> fictionize_independent_fields(Person)
  #   %{
  #     age: 15843121,
  #     email: "nxVlzIH6gL",
  #     gender: "pXtt4yNurUqMP4uV7UMw5N6b5WUprNWXmhgD8vdDtMtpW99jRjR4Qj1okcrGUdsKRzQjiw7xS5rd82GJi4v7ZRQFJzOh",
  #     id: 50862806,
  #     inserted_at: ~N[2020-08-22 09:05:01.059052],
  #     name: "hifTNGdcXd40xqv02XXnHEEbvajDQgA7VZ36cQJsiI1lqUu40vxlCNBJHenx6vP0SfyEqo",
  #     updated_at: ~N[2020-08-22 09:05:01.061624]
  #   }
  #
  defp fictionize_independent_fields(ecto_schema) do
    ecto_schema
    |> get_independent_fields()
    |> Enum.reduce(%{}, fn field, acc ->
      Map.put(acc, field, fictionize_independent_field(ecto_schema, field))
    end)
  end

  defp fictionize_independent_fields(%{} = predefined_value_map, opts) when is_list(opts) do
    predefined_value_map
    |> Map.keys()
    |> Enum.reduce(%{}, fn key, acc ->
      Map.put(acc, key, interpret_independent_value(opts, predefined_value_map, key))
    end)
  end

  defp fictionize_independent_fields(ecto_schema, opts) when is_list(opts) do
    fictionize_independent_fields(fictionize_independent_fields(ecto_schema), opts)
  end

  defp interpret_independent_value(opts, predefined_value_map, key) do
    cond do
      Keyword.get(opts, key) == :null -> nil
      is_nil(Keyword.get(opts, key)) -> Map.get(predefined_value_map, key)
      true -> Keyword.get(opts, key)
    end
  end

  # Fictionize if the field is an Ecto belongs to association fields
  defp fictionize_belongs_to_association_field(ecto_schema, field) do
    ecto_schema
    |> get_association_field_type(field)
    |> fictionize()
  end

  defp fictionize_belongs_to_association_field(ecto_schema, field, opts) when is_list(opts) do
    ecto_schema
    |> get_association_field_type(field)
    |> fictionize(Keyword.get(opts, field))
  end

  defp fictionize_belongs_to_association_field(ecto_schema, field, repo) do
    ecto_schema
    |> get_association_field_type(field)
    |> fictionize(repo)
  end

  defp fictionize_belongs_to_association_field(ecto_schema, field, repo, opts)
       when is_list(opts) do
    ecto_schema
    |> get_association_field_type(field)
    |> fictionize(repo, Keyword.get(opts, field))
  end

  # Fictionize all the Ecto belongs to association fields
  defp fictionize_belongs_to_association_fields(ecto_schema) do
    ecto_schema
    |> get_belongs_to_association_fields()
    |> Enum.reduce(%{}, fn field, acc ->
      Map.put(
        acc,
        get_association_field_key(ecto_schema, field),
        ecto_schema
        |> fictionize_belongs_to_association_field(field)
        |> detupelize()
        |> Map.get(
          ecto_schema
          |> get_related_field_ecto_schema(field)
        )
      )
    end)
  end

  defp fictionize_belongs_to_association_fields(ecto_schema, repo) when is_atom(repo) do
    ecto_schema
    |> get_belongs_to_association_fields()
    |> Enum.reduce(%{}, fn field, acc ->
      Map.put(
        acc,
        get_association_field_key(ecto_schema, field),
        ecto_schema
        |> fictionize_belongs_to_association_field(field, repo)
        |> detupelize()
        |> Map.get(
          ecto_schema
          |> get_related_field_ecto_schema(field)
        )
      )
    end)
  end

  defp fictionize_belongs_to_association_fields(ecto_schema, opts) when is_list(opts) do
    ecto_schema
    |> get_belongs_to_association_fields()
    |> Enum.reduce(%{}, fn field, acc ->
      association_field_key = get_association_field_key(ecto_schema, field)

      association_field_value =
        cond do
          not is_nil(Keyword.get(opts, association_field_key)) ->
            Keyword.get(opts, association_field_key)

          is_map(Keyword.get(opts, field)) ->
            association_ecto_schema =
              opts |> Keyword.get(field) |> Map.get(:__meta__) |> Map.get(:schema)

            primary_key = association_ecto_schema.__schema__(:primary_key) |> Enum.at(0)

            opts
            |> Keyword.get(field)
            |> Map.from_struct()
            |> Map.to_list()
            |> Keyword.get(primary_key)

          true ->
            nil
        end

      Map.put(
        acc,
        association_field_key,
        interpret_belongs_to_association_value(association_field_value, ecto_schema, field, opts)
      )
    end)
  end

  defp interpret_belongs_to_association_value(
         association_field_value,
         ecto_schema,
         field,
         opts
       ) do
    cond do
      association_field_value == :null ->
        nil

      is_nil(association_field_value) ->
        ecto_schema
        |> fictionize_belongs_to_association_field(field, opts)
        |> detupelize()
        |> Map.get(
          ecto_schema
          |> get_related_field_ecto_schema(field)
        )

      true ->
        association_field_value
    end
  end

  defp fictionize_belongs_to_association_fields(ecto_schema, repo, opts)
       when is_atom(repo) and is_list(opts) do
    ecto_schema
    |> get_belongs_to_association_fields()
    |> Enum.reduce(%{}, fn field, acc ->
      association_field_key = get_association_field_key(ecto_schema, field)

      association_field_value =
        cond do
          not is_nil(Keyword.get(opts, association_field_key)) ->
            Keyword.get(opts, association_field_key)

          is_map(Keyword.get(opts, field)) ->
            association_ecto_schema =
              opts |> Keyword.get(field) |> Map.get(:__meta__) |> Map.get(:schema)

            primary_key = association_ecto_schema.__schema__(:primary_key) |> Enum.at(0)

            opts
            |> Keyword.get(field)
            |> Map.from_struct()
            |> Map.to_list()
            |> Keyword.get(primary_key)

          true ->
            nil
        end

      Map.put(
        acc,
        association_field_key,
        interpret_belongs_to_association_value(
          association_field_value,
          ecto_schema,
          field,
          repo,
          opts
        )
      )
    end)
  end

  defp interpret_belongs_to_association_value(
         association_field_value,
         ecto_schema,
         field,
         repo,
         opts
       ) do
    cond do
      association_field_value == :null ->
        nil

      is_nil(association_field_value) ->
        ecto_schema
        |> fictionize_belongs_to_association_field(field, repo, opts)
        |> detupelize()
        |> Map.get(
          ecto_schema
          |> get_related_field_ecto_schema(field)
        )

      true ->
        association_field_value
    end
  end

  ###################################
  #     ECTO SCHEMA REFLECTIONS     #
  ###################################

  # Return all fields that an ecto schema has
  #
  # Examples:
  #
  #   iex> get_fields(Person)
  #   [:id, :name, :age, :gender, :email, :country_id, :parent_id, :inserted_at, :updated_at]
  #
  defp get_fields(ecto_schema) do
    ecto_schema.__schema__(:fields)
  end

  # Return primary key field of an ecto schema.
  #
  # Examples:
  #
  #   iex> get_primary_key_field(Person)
  #   :id
  #
  defp get_primary_key_field(ecto_schema) do
    :primary_key
    |> ecto_schema.__schema__()
    |> Enum.at(0)
  end

  # Return type of a field in an ecto schema
  #
  # Examples:
  #
  #   iex> get_field_type(Person, :name)
  #   :string
  #
  #   iex> get_field_type(Person, :age)
  #   :integer
  #
  defp get_field_type(ecto_schema, field) do
    ecto_schema.__schema__(:type, field)
  end

  # Return all fields that has a primitive types.
  #
  # Examples:
  #
  #   iex> get_independent_fields(Person)
  #   [:id, :name, :age, :gender, :email, :inserted_at, :updated_at]
  #
  defp get_independent_fields(ecto_schema) do
    ecto_schema
    |> get_fields()
    |> not_in(get_association_field_keys(ecto_schema))
  end

  # Return all fields that has an association to other ecto schema.
  #
  # Examples:
  #
  #   iex> get_any_association_fields(Person)
  #   [:nationality, :parent]
  #
  defp get_any_association_fields(ecto_schema) do
    ecto_schema.__schema__(:associations)
  end

  # Return all field keys that has an association to other ecto schema.
  #
  # Examples:
  #
  #   iex> get_association_field_keys(Person)
  #   [:country_id, :parent_id]
  #
  defp get_association_field_keys(ecto_schema) do
    ecto_schema
    |> get_any_association_fields()
    |> Enum.map(fn field -> get_association_field_key(ecto_schema, field) end)
  end

  # Return all fields that has a belong to association type.
  #
  # Examples:
  #
  #   iex> get_belongs_to_association_fields(Person)
  #   [:nationality, :parent]
  #
  defp get_belongs_to_association_fields(ecto_schema) do
    ecto_schema
    |> get_any_association_fields()
    |> Enum.filter(fn field ->
      ecto_schema
      |> get_association_field_type(field)
      |> is_belongs_to_association?()
    end)
  end

  # Return association type of a field.
  #
  # Examples:
  #
  #   iex> get_association_field_type(Person, :nationality)
  #   %Ecto.Association.BelongsTo{}
  #
  #   iex> get_association_field_type(Person, :name)
  #   nil
  #
  defp get_association_field_type(ecto_schema, field) do
    ecto_schema.__schema__(:association, field)
  end

  # Return association key of a field.
  #
  # Examples:
  #
  #   iex> get_association_field_key(Person, :nationality)
  #   :country_id
  #
  #   iex> get_association_field_key(Person, :parent)
  #   :parent_id
  #
  defp get_association_field_key(ecto_schema, field) do
    :association
    |> ecto_schema.__schema__(field)
    |> get_association_field_key()
  end

  defp get_association_field_key(%Ecto.Association.Has{}), do: :not_supported_yet
  defp get_association_field_key(%Ecto.Association.BelongsTo{owner_key: key}), do: key
  defp get_association_field_key(%Ecto.Association.ManyToMany{}), do: :not_supported_yet
  defp get_association_field_key(_), do: :not_supported_yet

  # Return all fields that has a belong to association type.
  #
  # Examples:
  #
  #   iex> get_association_field_ecto_schema(Person, :nationality)
  #   Fictitious.Country
  #
  #   iex> get_association_field_ecto_schema(Person, :name)
  #   Fictitious.Person
  #
  defp get_association_field_ecto_schema(ecto_schema, field) do
    :association
    |> ecto_schema.__schema__(field)
    |> Map.get(:related)
  end

  # Return related fields that has a belong to association type.
  #
  # Examples:
  #
  #   iex> get_related_field_ecto_schema(Person, :nationality)
  #   :id
  #
  #   iex> get_related_field_ecto_schema(SocialMediaInformation, :email)
  #   :email
  #
  defp get_related_field_ecto_schema(ecto_schema, field) do
    :association
    |> ecto_schema.__schema__(field)
    |> Map.get(:related_key)
  end

  # Check whether an input struct in an encto belongs to struct.
  defp is_belongs_to_association?(%Ecto.Association.BelongsTo{}), do: true
  defp is_belongs_to_association?(_), do: false

  ###################################
  #        RANDOM GENERATORS        #
  ###################################

  defp gen_random(:id), do: Misc.Random.number()
  defp gen_random(:binary_id), do: <<Enum.random(0..255)>>
  defp gen_random(:integer), do: Misc.Random.number()
  defp gen_random(:float), do: Misc.Random.number()
  defp gen_random(:boolean), do: Misc.Random.number(1) |> Integer.mod(2) == 0
  defp gen_random(:string), do: Misc.Random.number(2) |> Misc.Random.string()
  defp gen_random(:binary), do: <<Enum.random(0..255)>>
  defp gen_random({:array, inner_type}), do: [gen_random(inner_type)]
  defp gen_random(:map), do: %{gen_random(:integer) => gen_random(:integer)}
  defp gen_random({:map, inner_type}), do: %{gen_random(inner_type) => gen_random(inner_type)}
  defp gen_random(:decimal), do: Misc.Random.number() |> Decimal.new()
  defp gen_random(:date), do: Date.utc_today()
  defp gen_random(:time), do: Time.utc_now()
  defp gen_random(:time_usec), do: Time.utc_now()
  defp gen_random(:naive_datetime), do: DateTime.utc_now() |> DateTime.to_naive()
  defp gen_random(:naive_datetime_usec), do: DateTime.utc_now() |> DateTime.to_naive()
  defp gen_random(:utc_datetime), do: DateTime.utc_now()
  defp gen_random(:utc_datetime_usec), do: DateTime.utc_now()
  defp gen_random(:ksuid), do: Ksuid.generate()
  defp gen_random(_), do: Ksuid.generate()

  ###################################
  #             HELPERS             #
  ###################################

  defp detupelize({_status, data}), do: data

  defp not_in(input_list, comparing_list),
    do: Enum.reject(input_list, fn field -> field in comparing_list end)
end
