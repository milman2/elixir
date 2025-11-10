defmodule ElixirGist.GistsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ElixirGist.Gists` context.
  """

  @doc """
  Generate a gist.
  """
  def gist_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        description: "some description",
        markup_text: "some markup_text",
        name: "some name"
      })

    {:ok, gist} = ElixirGist.Gists.create_gist(scope, attrs)
    gist
  end

  @doc """
  Generate a saved_gist.
  """
  def saved_gist_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{

      })

    {:ok, saved_gist} = ElixirGist.Gists.create_saved_gist(scope, attrs)
    saved_gist
  end
end
