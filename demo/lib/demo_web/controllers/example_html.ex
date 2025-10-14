defmodule DemoWeb.ExampleHTML do
  @moduledoc """
  This module contains pages rendered by ExampleController.

  See the `example_html` directory for all templates available.
  """
  use DemoWeb, :html

  embed_templates "example_html/*"
end
