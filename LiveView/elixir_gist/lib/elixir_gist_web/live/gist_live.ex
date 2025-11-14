defmodule ElixirGistWeb.GistLive do
  use ElixirGistWeb, :live_view

  alias ElixirGist.Gists

  def mount(%{"id" => id}, _session, socket) do
    gist = Gists.get_gist!(socket.assigns.current_scope, id)
    {:ok, assign(socket, gist: gist)}
  end
end
