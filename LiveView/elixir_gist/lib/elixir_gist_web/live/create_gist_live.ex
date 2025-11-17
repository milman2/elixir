defmodule ElixirGistWeb.CreateGistLive do
  use ElixirGistWeb, :live_view

  alias ElixirGist.Gists
  alias ElixirGist.Gists.Gist

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
