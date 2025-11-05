# Ecto
- Database wrapper and query generator

## Adapter
- PostgreSQL
- MySQL
- SQLite

```shell
mix new friends --sup
cd friends
```

```elixir
defp deps do
    [
        {:ecto_sql, "~> 3.2"},
        {:postgrex, "~> 0.15"}
    ]
end
```

```shell
mix deps.get
```

## Repository
```shell
mix ecto.gen.repo -r Friends.Repo
```

```elixir
config :friends, ecto_repo: Friends.Repo,
    database: "friends_repo",
    username: "postgres",
    password: "",
    hostname: "localhost"
```

```shell
mix ecto.create
```

## Migration
```shell
mix ecto.gen.migration create_people
```

- priv/repo/migrations/
```elixir
defmodule Friends.Repo.Migrations.CreatePeople do
    use Ecto.Migration

    def change do
        create table(:people) do
            add :name, :string, null: false
            add :age, :integer, default: 0
        end
    end
end
```

```shell
mix ecto.migrate
```

## Schema
- lib/friends/person.ex
```elixir
defmodule Friends.Person do
    use Ecto.Schema

    import Ecto.Changeset

    schema "people" do
        field :name, :string
        field :age, :integer, default: 0
    end
end
```

```shell
iex -S mix
%Friends.Person{}
person = %Friends.Person{name: "Tom", age: 11}
person.name
Map.get(person, :name)
%{name: name} = person
name
%{person | age: 18}
Map.put(person, :name, "Jerry")
```

## [Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html#summary)
```shell
%Ecto.Changeset()
%Ecto.Changeset.cast(%Friends.Person{name: "Bob"}, %{}, [:name, :age])
# arg1 : 본래의 데이터
# arg2 : 만들고자 하는 변경 사항
# arg3 : 변경을 허용하는 필드 목록
Ecto.Changeset.cast(%Friends.Person{name: "Bob"}, %{"name" => "Jack"}, [:name, :age])
Ecto.Changeset.cast(%Friends.Person{name: "Bob"}, %{"name" => "Jack"}, []) # 명시적으로 허용되지 않은 새 이름이 무시됨

Ecto.Changeset.change(%Friends.Person{name: "Bob"}, %{name: ""}) # change : 변경 사항을 필터링 하지 않음.
```

## Validation
```elixir
def changeset(struct, params) do
    struct
    |> cast(params, [:name, :age])
    |> validate_required([:name])
    |> validate_length(:name, min: 2)
    |> validate_fictional_name()
end

Friends.Person.changeset(%Friends.Person{}, %{name: ""})
Friends.Person.changeset(%Friends.Person{}, %{"name" => "A"})
```
- validate_acceptance/3
- validate_change/3 & /4
- validate_confirmation/3
- validate_exclusion/4 & validate_inclusion/4
- validate_format/4
- validate_number/3
- validate_subset/4

### Custom validator
```elixir
@fictional_names ["Black Panther", "Wonder Woman", "Spiderman"]
def validate_fictional_name(changeset) do
  name = get_field(changeset, :name)

  if name in @fictional_names do
    changeset
  else
    add_error(changeset, :name, "is not a superhero")
  end
end
```

## put_change/3
```elixir
def set_name_if_anonymous(changeset) do
  name = get_field(changeset, :name)

  if is_nil(name) do
    put_change(changeset, :name, "Anonymous")
  else
    changeset
  end
end

def registration_changeset(struct, params) do
  struct
  |> cast(params, [:name, :age])
  |> set_name_if_anonymous()
end

Friends.Person.registration_changeset(%Friends.Person{}, %{})

def sign_up(params) do
  %Friends.Person{}
  |> Friends.Person.registration_changeset(params)
  |> Repo.insert()
end
```

## Association
- Belongs To / Has Many
- Belongs To / Has One
- Many To Many
### Belongs To / Has Many
- Movie - Character
```shell
mix ecto.gen.migration create_movies
```

```elixir
# priv/repo/migrations/*_create_movies.exs
defmodule Friends.Repo.Migrations.CreateMovies do
  use Ecto.Migration

  def change do
    create table(:movies) do
      add :title, :string
      add :tagline, :string
    end
  end
end

# lib/friends/movie.ex
defmodule Friends.Movie do
  use Ecto.Schema

  schema "movies" do
    field :title, :string
    field :tagline, :string
    has_many :characters, Friends.Character
  end
end
```

```shell
mix ecto.gen.migration create_characters
```

```elixir
# priv/migrations/*_create_characters.exs
defmodule Friends.Repo.Migrations.CreateCharacters do
  use Ecto.Migration

  def change do
    create table(:characters) do
      add :name, :string
      add :movie_id, references(:movies)
    end
  end
end

# lib/friends/character.ex
defmodule Friends.Character do
  use Ecto.Schema

  schema "characters" do
    field :name, :string
    belongs_to :movie, Friends.Movie
  end
end
```

```shell
mix ecto.migrate
```

### Belongs To / Has One
- Movie - Distributor

```shell
mix ecto.gen.migration create_distributors
```

```elixir
# priv/repo/migrations/*_create_distributors.exs
defmodule Friends.Repo.Migrations.CreateDistributors do
  use Ecto.Migration

  def change do
    create table(:distributors) do
      add :name, :string
      add :movie_id, references(:movies)
    end
    
    create unique_index(:distributors, [:movie_id])
  end
end

# lib/friends/distributor.ex
defmodule Friends.Distributor do
  use Ecto.Schema

  schema "distributors" do
    field :name, :string
    belongs_to :movie, Friends.Movie
  end
end

# lib/friends/movie.ex
defmodule Friends.Movie do
  use Ecto.Schema

  schema "movies" do
    field :title, :string
    field :tagline, :string
    has_many :characters, Friends.Character
    has_one :distributor, Friends.Distributor # I'm new!
  end
end
```

```shell
mix ecto.migrate
```

### Many To Many
- Movie - Actor

```shell
mix ecto.gen.migration create_actors
```

```elixir
# priv/migrations/*_create_actors.ex
defmodule Friends.Repo.Migrations.CreateActors do
  use Ecto.Migration

  def change do
    create table(:actors) do
      add :name, :string
    end
  end
end
```

```shell
mix ecto.gen.migration create_movies_actors
```

```elixir
# priv/migrations/*_create_movies_actors.ex
defmodule Friends.Repo.Migrations.CreateMoviesActors do
  use Ecto.Migration

  def change do
    create table(:movies_actors) do
      add :movie_id, references(:movies)
      add :actor_id, references(:actors)
    end

    create unique_index(:movies_actors, [:movie_id, :actor_id])
  end
end

# lib/friends/movie.ex
defmodule Friends.Movie do
  use Ecto.Schema

  schema "movies" do
    field :title, :string
    field :tagline, :string
    has_many :characters, Friends.Character
    has_one :distributor, Friends.Distributor
    many_to_many :actors, Friends.Actor, join_through: "movies_actors" # I'm new!
  end
end

# lib/friends/actor.ex
defmodule Friends.Actor do
  use Ecto.Schema

  schema "actors" do
    field :name, :string
    many_to_many :movies, Friends.Movie, join_through: "movies_actors"
  end
end
```

```shell
mix ecto.migrate
```

## Saving Associated Data
### Belongs To / Has Many
- build_assoc/3
- arg1: The struct of the record we want to save.
- arg2: The name of the association
- arg3: Any attributes we want to assign to the associated record we are saving.
```elixir
alias Friends.{Movie, Character, Repo}
movie = %Movie{title: "Ready Player One", tagline: "Something about video games"}
movie = Repo.insert!(movie)

character = Ecto.build_assoc(movie, :characters, %{name: "Wade Watts"})
Repo.insert!(character)

distributor = Ecto.build_assoc(movie, :distributor, %{name: "Netflix"})
Repo.insert!(distributor)
```

### Many to Many
- put_assoc/4
```elixir
alias Friends.Actor
actor = %Actor{name: "Tyler Sheridan"}
actor = Repo.insert!(actor)

# preload
movie = Repo.preload(movie, [:distributor, :characters, :actors])
movie_changeset = Ecto.Changeset.change(movie)
movie_actors_changeset = movie_changeset |> Ecto.Changeset.put_assoc(:actors, [actor])
Repo.update!(movie_actors_changeset)

changeset = movie_changeset |> Ecto.Changeset.put_assoc(:actors, [%{name: "Gary"}]) # 생성하고자 하는 새 배우의 속성들
Repo.update!(changeset)
```

## Querying
### Fetching Records by ID
- Repo.get/3
```elixir
alias Friends.{Repo, Movie}
Repo.get(Movie, 1)
```

### Fetching Records by Attribute
- Repo.get_by/3
```elixir
Repo.get_by(Movie, title: "Ready Player One")
```

## Writing Queries with Ecto.Query
- Ecto.Query.from/2
- Repo.all/2
```elixir
import Ecto.Query
query = from(Movie)
Repo.all(query)
``` 

### 키워드 기반 쿼리
- from
```elixir
query = from(Movie, where: [title: "Ready Player One"], select: [:title, :tagline])
Repo.all(query)

# binding
query = from(m in Movie, where: m.id < 2, select: m.title) 
Repo.all(query)

query = from(m in Movie, where: m.id < 2, select: {m.title})
Repo.all(query)
```

### 매크로 기반 쿼리
- select
- where
```elixir
query = select(Movie, [m], m.title)
Repo.all(query)

Movie
 |> where([m], m.id < 2)
 |> select([m], {m.title})
 |> Repo.all
```

```elixir
title = "Ready Player One"
query = from(m in Movie, where: m.title == ^title, select: m.tagline)
Repo.all(query)
```

- Ecto.Query.first/2
- Ecto.Query.last/2
```elixir
first(Movie)
Movie |> first() |> Repo.one()
Movie |> last() |> Repo.one()
```

## Querying for Associated data
### Preloading
```elixir
Repo.all(from m in Movie, preload: [:actors])

query = from(m in Movie, join: a in assoc(m, :actors), preload: [actors: a])
Repo.all(query)

Repo.all from m in Movie,
  join: a in assoc(m, :actors),
  where: a.name == "John Wayne",
  preload: [actors: a]

movie = Repo.get(Movie, 1)  
movie = Repo.preload(movie, :actors)
movie.actors
```
### Using Join Statements
```elixir
alias Friends.Character
query = from m in Movie,
            join: c in Character,
            on: m.id == c.movie_id,
            where: c.name == "Wade Watts",
            select: {m.title, c.name}
Repo.all(query)

movies = from m in Movie, where: [stars: 5]
from c in Character,
  join: ^movies,
  on: [id: c.movie_id], # keyword list
  where: c.name == "Wade Watts",
  select: {m.title, c.name}
```