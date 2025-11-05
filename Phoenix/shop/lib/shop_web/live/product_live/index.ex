defmodule ShopWeb.ProductLive.Index do
  use ShopWeb, :live_view

  alias Shop.Products

  def mount(_params, _session, socket) do
    products = Products.list_products()
    likes =
      products
      |> Enum.map(fn product -> {product.id, 0} end)
      |> Map.new()
    dbg(likes)
    socket =
      socket
      |> assign(:products, products)
      |> assign(:likes, likes)
    {:ok, socket}
  end

  def handle_event("like", %{"id" => id}, socket) do
    id = String.to_integer(id)
    likes = Map.put(socket.assigns.likes, id, socket.assigns.likes[id] + 1)
    socket = assign(socket, :likes, likes)
    dbg("LIKED")
    {:noreply, socket}
  end

  def handle_event("dislike", values, socket) do
    id = String.to_integer(values["id"])
    likes = Map.put(socket.assigns.likes, id, socket.assigns.likes[id] - 1)
    socket = assign(socket, :likes, likes)
    dbg("DISLIKED")
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Products</h1>
      <div :for={product <- @products}>
        <p>{product.name}-Likes: {@likes[product.id]}</p>
        <.icon
          name="hero-hand-thumb-down-mini"
          class="size-4 cursor-pointer"
          phx-click="dislike"
          phx-value-id={product.id}
        />
        <.icon
          name="hero-hand-thumb-up-mini"
          class="size-4 cursor-pointer"
          phx-click="like"
          phx-value-id={product.id}
        />
      </div>
    </div>
    """
  end
end
