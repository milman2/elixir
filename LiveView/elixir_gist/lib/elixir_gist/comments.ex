defmodule ElixirGist.Comments do
  @moduledoc """
  The Comments context.
  """

  import Ecto.Query, warn: false
  alias ElixirGist.Repo

  alias ElixirGist.Comments.Comment
  alias ElixirGist.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any comment changes.

  The broadcasted messages match the pattern:

    * {:created, %Comment{}}
    * {:updated, %Comment{}}
    * {:deleted, %Comment{}}

  """
  def subscribe_comments(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(ElixirGist.PubSub, "user:#{key}:comments")
  end

  defp broadcast_comment(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(ElixirGist.PubSub, "user:#{key}:comments", message)
  end

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments(scope)
      [%Comment{}, ...]

  """
  def list_comments(%Scope{} = scope) do
    Repo.all_by(Comment, user_id: scope.user.id)
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(scope, 123)
      %Comment{}

      iex> get_comment!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(%Scope{} = scope, id) do
    Repo.get_by!(Comment, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(scope, %{field: value})
      {:ok, %Comment{}}

      iex> create_comment(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(%Scope{} = scope, attrs) do
    with {:ok, comment = %Comment{}} <-
           %Comment{}
           |> Comment.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_comment(scope, {:created, comment})
      {:ok, comment}
    end
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(scope, comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(scope, comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Scope{} = scope, %Comment{} = comment, attrs) do
    true = comment.user_id == scope.user.id

    with {:ok, comment = %Comment{}} <-
           comment
           |> Comment.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_comment(scope, {:updated, comment})
      {:ok, comment}
    end
  end

  @doc """
  Deletes a comment.

  ## Examples

      iex> delete_comment(scope, comment)
      {:ok, %Comment{}}

      iex> delete_comment(scope, comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Scope{} = scope, %Comment{} = comment) do
    true = comment.user_id == scope.user.id

    with {:ok, comment = %Comment{}} <-
           Repo.delete(comment) do
      broadcast_comment(scope, {:deleted, comment})
      {:ok, comment}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(scope, comment)
      %Ecto.Changeset{data: %Comment{}}

  """
  def change_comment(%Scope{} = scope, %Comment{} = comment, attrs \\ %{}) do
    true = comment.user_id == scope.user.id

    Comment.changeset(comment, attrs, scope)
  end
end
