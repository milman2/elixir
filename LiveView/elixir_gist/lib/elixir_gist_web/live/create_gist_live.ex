defmodule ElixirGistWeb.CreateGistLive do
  use ElixirGistWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  #@impl true
  # def render(assigns) do
  #   ~H"""
  #   <div>
  #     <h1>Create Gist</h1>
  #   </div>
  #   """
  #end
end
