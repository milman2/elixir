defmodule ElixirGist.Gists.Gist do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "gists" do
    field :name, :string
    field :description, :string
    field :markup_text, :string

    belongs_to :user, ElixirGist.Accounts.User
    has_many :saved_gists, ElixirGist.Gists.SavedGist
    has_many :comments, ElixirGist.Comments.Comment

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(gist, attrs, user_scope) do
    gist
    |> cast(attrs, [:name, :description, :markup_text])
    |> validate_required([:name, :description, :markup_text])
    |> put_change(:user_id, user_scope.user.id)
  end
end
