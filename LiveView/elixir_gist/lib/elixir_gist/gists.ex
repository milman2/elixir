defmodule ElixirGist.Gists do
  @moduledoc """
  The Gists context.
  """

  import Ecto.Query, warn: false
  alias ElixirGist.Repo

  alias ElixirGist.Gists.Gist
  alias ElixirGist.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any gist changes.

  The broadcasted messages match the pattern:

    * {:created, %Gist{}}
    * {:updated, %Gist{}}
    * {:deleted, %Gist{}}

  """
  def subscribe_gists(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(ElixirGist.PubSub, "user:#{key}:gists")
  end

  defp broadcast_gist(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(ElixirGist.PubSub, "user:#{key}:gists", message)
  end

  @doc """
  Returns the list of gists.

  ## Examples

      iex> list_gists(scope)
      [%Gist{}, ...]

  """
  def list_gists(%Scope{} = scope) do
    Repo.all_by(Gist, user_id: scope.user.id)
  end

  @doc """
  Gets a single gist.

  Raises `Ecto.NoResultsError` if the Gist does not exist.

  ## Examples

      iex> get_gist!(scope, 123)
      %Gist{}

      iex> get_gist!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_gist!(%Scope{} = scope, id) do
    Repo.get_by!(Gist, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a gist.

  ## Examples

      iex> create_gist(scope, %{field: value})
      {:ok, %Gist{}}

      iex> create_gist(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_gist(%Scope{} = scope, attrs) do
    with {:ok, gist = %Gist{}} <-
           %Gist{}
           |> Gist.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_gist(scope, {:created, gist})
      {:ok, gist}
    end
  end

  @doc """
  Updates a gist.

  ## Examples

      iex> update_gist(scope, gist, %{field: new_value})
      {:ok, %Gist{}}

      iex> update_gist(scope, gist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_gist(%Scope{} = scope, %Gist{} = gist, attrs) do
    true = gist.user_id == scope.user.id

    with {:ok, gist = %Gist{}} <-
           gist
           |> Gist.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_gist(scope, {:updated, gist})
      {:ok, gist}
    end
  end

  @doc """
  Deletes a gist.

  ## Examples

      iex> delete_gist(scope, gist)
      {:ok, %Gist{}}

      iex> delete_gist(scope, gist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_gist(%Scope{} = scope, %Gist{} = gist) do
    true = gist.user_id == scope.user.id

    with {:ok, gist = %Gist{}} <-
           Repo.delete(gist) do
      broadcast_gist(scope, {:deleted, gist})
      {:ok, gist}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking gist changes.

  ## Examples

      iex> change_gist(scope, gist)
      %Ecto.Changeset{data: %Gist{}}

  """
  def change_gist(%Scope{} = scope, %Gist{} = gist, attrs \\ %{}) do
    true = gist.user_id == scope.user.id

    Gist.changeset(gist, attrs, scope)
  end

  alias ElixirGist.Gists.SavedGist
  alias ElixirGist.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any saved_gist changes.

  The broadcasted messages match the pattern:

    * {:created, %SavedGist{}}
    * {:updated, %SavedGist{}}
    * {:deleted, %SavedGist{}}

  """
  def subscribe_saved_gists(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(ElixirGist.PubSub, "user:#{key}:saved_gists")
  end

  defp broadcast_saved_gist(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(ElixirGist.PubSub, "user:#{key}:saved_gists", message)
  end

  @doc """
  Returns the list of saved_gists.

  ## Examples

      iex> list_saved_gists(scope)
      [%SavedGist{}, ...]

  """
  def list_saved_gists(%Scope{} = scope) do
    Repo.all_by(SavedGist, user_id: scope.user.id)
  end

  @doc """
  Gets a single saved_gist.

  Raises `Ecto.NoResultsError` if the Saved gist does not exist.

  ## Examples

      iex> get_saved_gist!(scope, 123)
      %SavedGist{}

      iex> get_saved_gist!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_saved_gist!(%Scope{} = scope, id) do
    Repo.get_by!(SavedGist, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a saved_gist.

  ## Examples

      iex> create_saved_gist(scope, %{field: value})
      {:ok, %SavedGist{}}

      iex> create_saved_gist(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_saved_gist(%Scope{} = scope, attrs) do
    with {:ok, saved_gist = %SavedGist{}} <-
           %SavedGist{}
           |> SavedGist.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_saved_gist(scope, {:created, saved_gist})
      {:ok, saved_gist}
    end
  end

  @doc """
  Updates a saved_gist.

  ## Examples

      iex> update_saved_gist(scope, saved_gist, %{field: new_value})
      {:ok, %SavedGist{}}

      iex> update_saved_gist(scope, saved_gist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_saved_gist(%Scope{} = scope, %SavedGist{} = saved_gist, attrs) do
    true = saved_gist.user_id == scope.user.id

    with {:ok, saved_gist = %SavedGist{}} <-
           saved_gist
           |> SavedGist.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_saved_gist(scope, {:updated, saved_gist})
      {:ok, saved_gist}
    end
  end

  @doc """
  Deletes a saved_gist.

  ## Examples

      iex> delete_saved_gist(scope, saved_gist)
      {:ok, %SavedGist{}}

      iex> delete_saved_gist(scope, saved_gist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_saved_gist(%Scope{} = scope, %SavedGist{} = saved_gist) do
    true = saved_gist.user_id == scope.user.id

    with {:ok, saved_gist = %SavedGist{}} <-
           Repo.delete(saved_gist) do
      broadcast_saved_gist(scope, {:deleted, saved_gist})
      {:ok, saved_gist}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking saved_gist changes.

  ## Examples

      iex> change_saved_gist(scope, saved_gist)
      %Ecto.Changeset{data: %SavedGist{}}

  """
  def change_saved_gist(%Scope{} = scope, %SavedGist{} = saved_gist, attrs \\ %{}) do
    true = saved_gist.user_id == scope.user.id

    SavedGist.changeset(saved_gist, attrs, scope)
  end
end
