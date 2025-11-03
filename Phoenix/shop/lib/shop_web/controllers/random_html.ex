defmodule ShopWeb.RandomHTML do
  use ShopWeb, :html

  def random(assigns) do
    ~H"""
    <div>
      <h1>This is a random page</h1>
    </div>
    """
  end

  #embed_templates "random_html/*"
end
