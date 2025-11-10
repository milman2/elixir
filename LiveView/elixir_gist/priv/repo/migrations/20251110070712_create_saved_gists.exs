defmodule ElixirGist.Repo.Migrations.CreateSavedGists do
  use Ecto.Migration

  def change do
    create table(:saved_gists, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :gist_id, references(:gists, type: :binary_id, on_delete: :delete_all)
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:saved_gists, [:user_id])
    create index(:saved_gists, [:gist_id])
  end
end
