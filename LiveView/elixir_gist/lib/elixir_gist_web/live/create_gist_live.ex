defmodule ElixirGistWeb.CreateGistLive do
  use ElixirGistWeb, :live_view

  alias ElixirGist.Gists.Gist
  alias ElixirGist.Gists

  def mount(_params, _session, socket) do
    changeset = Gist.changeset(%Gist{}, %{}, socket.assigns.current_scope)
    {:ok, assign(socket, form: to_form(changeset))}
  end

  def handle_event("validate", %{"gist" => params}, socket) do
    changeset = Gist.changeset(%Gist{}, params, socket.assigns.current_scope)
      |> Map.put(:action, :validate)
    {:noreply, assign(socket, form: to_form(changeset))}
  end

  # SELECT * FROM gists;
  def handle_event("create", %{"gist" => params}, socket) do
    case Gists.create_gist(socket.assigns.current_scope, params) do
      {:ok, _gist} ->
        # 새로운 빈 changeset 생성 (change_gist 대신)
        changeset = Gist.changeset(%Gist{}, %{}, socket.assigns.current_scope)

        socket =
          socket
          |> put_flash(:info, "Gist created successfully!")
          |> assign(form: to_form(changeset))

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
