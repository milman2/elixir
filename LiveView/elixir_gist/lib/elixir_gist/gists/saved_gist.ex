defmodule ElixirGist.Gists.SavedGist do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "saved_gists" do
    belongs_to :user, ElixirGist.Accounts.User
    belongs_to :gist, ElixirGist.Gists.Gist

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(saved_gist, attrs, user_scope) do
    saved_gist
    |> cast(attrs, [:gist_id])
    |> validate_required([:gist_id])
    |> put_change(:user_id, user_scope.user.id)
  end
end
