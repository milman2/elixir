defmodule ElixirGist.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "comments" do
    field :markup_text, :string

    belongs_to :user, ElixirGist.Accounts.User
    belongs_to :gist, ElixirGist.Gists.Gist

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comment, attrs, user_scope) do
    comment
    |> cast(attrs, [:markup_text, :gist_id])
    |> validate_required([:markup_text, :gist_id])
    |> put_change(:user_id, user_scope.user.id)
  end
end
