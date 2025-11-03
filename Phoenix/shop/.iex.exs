# Set up aliases - works when app is started with `iex -S mix`
# Uses Code.eval_string to avoid compile-time errors

if Code.ensure_loaded?(Shop.Product) do
  {_, _} = Code.eval_string("alias Shop.Product")
end

# Ecto.Query may not be available until app starts
if Code.ensure_loaded?(Ecto.Query) do
  {_, _} = Code.eval_string("import Ecto.Query")
end
