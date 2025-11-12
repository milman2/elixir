defmodule ElixirGistWeb.CreateGistLive do
  use ElixirGistWeb, :live_view

  alias ElixirGist.Gists.Gist

  def mount(_params, _session, socket) do
    changeset = Gist.changeset(%Gist{}, %{}, socket.assigns.current_scope)
    {:ok, assign(socket, form: to_form(changeset))}
  end
end
