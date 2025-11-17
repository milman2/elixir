defmodule ElixirGistWeb.GistLive do
  use ElixirGistWeb, :live_view
  use Timex

  alias ElixirGist.Gists
  alias ElixirGist.Gists.Gist

  def mount(%{"id" => id}, _session, socket) do
    gist = Gists.get_gist!(socket.assigns.current_scope, id)
    relative_time = Timex.format!(gist.updated_at, "{relative}", :relative)
    gist = Map.put(gist, :relative, relative_time)
    {:ok, assign(socket, gist: gist)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    case Gists.delete_gist(socket.assigns.current_scope, id) do
      {:ok, _gist} ->
        socket = put_flash(socket, :info, "Gist deleted successfully")
        {:noreply, push_navigate(socket, to: ~p"/create")}
      {:error, message} ->
        socket = put_flash(socket, :error, message)
        {:noreply, socket}
    end
  end

  def handle_event("edit", %{"id" => id}, socket) do
    gist = Gists.get_gist!(socket.assigns.current_scope, id)
    {:noreply, assign(socket, gist: gist)}
  end
end
