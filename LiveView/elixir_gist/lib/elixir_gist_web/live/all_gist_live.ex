defmodule ElixirGistWeb.AllGistLive do
  use ElixirGistWeb, :live_view

  alias ElixirGist.Gists
  alias ElixirGist.Gists.Gist

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    gists = Gists.list_gists(socket.assigns.current_scope)
    socket = assign(socket, gists: gists)
    {:noreply, socket}
  end

  def gist(assigns) do
    ~H"""
    <div>
      <%= @current_scope.user.email %>/<%= @gist.name %>
    </div>
    <div>
      <%= @gist.updated_at |> Timex.format!("{relative}", :relative) %>
    </div>
    <div>
      <%= @gist.description %>
    </div>
    <div>
      <%= @gist.markup_text |> html_escape() |> raw() %>
    </div>
    """
  end
end
