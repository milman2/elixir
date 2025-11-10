# LiveView
- rich
- real-time
- server-rendered HTML

- receive events
- update states
- (re-)render updates to a page as diffs

- declarative

## callback
- **render/1**
  - socket.assigns
  - HEEx template(~H sigil)
- **mount/3**
  - request parameters
  - session
  - socket (assigns)
- **handle_event/3**
  - phx-click attribute

- assign/3
- LiveComponent

## Example 1
```shell
mix phx.new counter --no-ecto
```

### /lib/counter_web/router.ex
```elixir
scope "/", CounterWeb do
  pipe_through :browser

  get "/", PageController, :index

  live "/counter", CounterLive
end
```

### /lib/counter_web/live/counter_live.ex
```elixir
defmodule CounterWeb.CounterLive do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    socket = assign(socket, :count, 0)
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>Count: <%= @count %></h1>
    <button phx-click="increment">+</button>
    <button phx-click="decrement">-</button>
    """
  end

  def handle_event("increment", _params, socket) do
    count = socket.assigns.count + 1
    socket = assign(socket, :count, count)
    {:noreply, socket}
  end

  def handle_event("decrement", _params, socket) do
    count = socket.assigns.count - 1
    socket = assign(socket, :count, count)
    {:noreply, socket}
  end
end
```

## Example 2
```elixir
defmodule MyAppWeb.ThermostatLive do
  use MyAppWeb, :live_view

  def render(assigns) do
    ~H"""
    Current temperature: {@temperature}°F
    <button phx-click="inc_temperature">+</button>
    """
  end

  def mount(_params, _session, socket) do
    temperature = 70 # Let's assume a fixed temperature for now
    {:ok, assign(socket, :temperature, temperature)}
  end

  def handle_event("inc_temperature", _params, socket) do
    {:noreply, update(socket, :temperature, &(&1 + 1))}
  end
end
```

## Parameters and Session
- mount(_params, _session, socket)

## Bindings
- phx-click
- handle_event
- Phoenix.LiveView.JS
- Phoenix.Component.form/1
- Phoenix.Component.inputs_for/1

## Navigation

## Generators
```shell
mix phx.gen.live Blog Post posts title:string body:text
```

## Compartmentalize state, markup, and events in LiveView
- function components
    - markup
    - event handling
- stateful components (LiveComponents)
    - Phoenix.LiveView.attach_hook/4
    - Phoenix.LiveComponent

## HEEx (HTML + EEx)
- HTML validation
- syntax-based components
- smart change tracking

- .heex
- ~H sigil : [Phoenix.Component.sigil_H/2](https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html#sigil_H/2)
- Phoenix.Component.assign/2
- Phoenix.Component.assign/3
- socket.assigns.name
- @name