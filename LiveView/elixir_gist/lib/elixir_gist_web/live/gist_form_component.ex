defmodule ElixirGistWeb.GistFormComponent do
  use ElixirGistWeb, :live_component

  alias ElixirGist.Gists
  alias ElixirGist.Gists.Gist

  def mount(socket) do
    {:ok, socket}
  end

  def update(assigns, socket) do
    socket = assign(socket, assigns)

    # form이 아직 없으면 새로 생성
    socket = if Map.has_key?(socket.assigns, :form) do
      socket
    else
      changeset = Gist.changeset(%Gist{}, %{}, socket.assigns.current_scope)
      assign(socket, form: to_form(changeset))
    end

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <!-- phx-target={@myself} 이 form의 submit은 부모가 아닌 이 컴포넌트로 전달됨 -->
      <.form for={@form} phx-submit="create" phx-change="validate" phx-target={@myself}>
        <div class="justify center px-28 w-full space-y-4 mb-10">
          <.input
            field={@form[:description]}
            placeholder="Gist Description..."
            autocomplete="off"
            phx-debounce="blur"
            class="bg-emDark-dark text-white border-white"
          />
          <div>
            <div class="flex p-2 items-center bg-emDark rounded-t-md border border-white">
              <div class="w-[300px] pl-2">
                  <.input
                  field={@form[:name]}
                  placeholder="Filename including extension..."
                  autocomplete="off"
                  phx-debounce="blur"
                  class="bg-emDark text-emLavender-dark border-0 font-brand font-bold text-base"
                  />
              </div>
            </div>
            <div id="gist-wrapper" class="flex w-full" phx-update="ignore">
              <textarea id="line-numbers" class="line-numbers rounded-bl-md" readonly>
              <%= "1\n" %>
              </textarea>
              <div class="flex-grow">
                <.input
                  id="text-area"
                  phx-hook="UpdateLineNumbers"
                  field={@form[:markup_text]}
                  type="textarea"
                  class="text-area w-full rounded-br-md font-mono bg-emDark-dark text-white border-white"
                  placeholder="Insert code..."
                  spellcheck="false"
                  autocomplete="off"
                  rows="20"
                  phx-debounce="blur"
                />
              </div>
            </div>
          </div>
          <div class="flex justify-end">
            <!-- .button 컴포넌트는 form 내부에 있으면 자동으로 type="submit" 버튼이 된다. -->
            <%= if @id == :new do %>
            <.button class="create_button" phx-disable-with="Creating...">Create gist</.button>
            <% else %>
            <.button class="create_button" phx-disable-with="Updating...">Update gist</.button>
            <% end %>
          </div>
        </div>
      </.form>
    </div>
    """
  end

  def handle_event("validate", %{"gist" => params}, socket) do
    changeset = Gist.changeset(%Gist{}, params, socket.assigns.current_scope)
      |> Map.put(:action, :validate)
    {:noreply, assign(socket, form: to_form(changeset))}
  end

  # SELECT * FROM gists;
  def handle_event("create", %{"gist" => params}, socket) do
    # socket.assigns.id를 사용 (hidden input 불필요)
    if socket.assigns.id == :new do
      create_gist(params, socket)
    else
      update_gist(params, socket)
    end
  end

  defp create_gist(params, socket) do
    case Gists.create_gist(socket.assigns.current_scope, params) do
      {:ok, gist} ->
        socket = push_event(socket, "clear-textareas", %{})
        # 새로운 빈 changeset 생성 (change_gist 대신)
        changeset = Gist.changeset(%Gist{}, %{}, socket.assigns.current_scope)

        socket =
          socket
          |> put_flash(:info, "Gist created successfully!")
          |> assign(form: to_form(changeset))

        #{:noreply, socket}
        {:noreply, push_navigate(socket, to: ~p"/gist?#{[id: gist.id]}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp update_gist(params, socket) do
    gist = ElixirGist.Repo.get!(Gist, socket.assigns.id)
    case Gists.update_gist(socket.assigns.current_scope, gist, params) do
      {:ok, gist} ->
        {:noreply, push_navigate(socket, to: ~p"/gist?#{[id: gist.id]}")}
      {:error, message} ->
        socket = put_flash(socket, :error, message)
        {:noreply, socket}
    end
  end
end
