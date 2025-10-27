defmodule MacroExample do
  # 입,출력이 AST로 이루어진다.
  defmacro cart({:+, _, [cart, item]}) do
    # 새로운 AST를 생성하여 반환한다.
    quote do
      cart = unquote(cart)
      item = unquote(item)
      new_cart = [item | cart]
      IO.puts("Added #{item} to cart, New cart: #{inspect(new_cart)}")
      new_cart
    end
  end

  defmacro cart({:-, _, [cart, item]}) do
    # 새로운 AST를 생성하여 반환한다.
    quote do
      cart = unquote(cart)
      item = unquote(item)
      new_cart = List.delete(cart, item)
      IO.puts("Removed #{item} from the cart, New cart: #{inspect(new_cart)}")
      new_cart
    end
  end
end

# IEx에서 실행:
# c "lib/macro_example.exs"
# import MacroExample
#
# 사용법:
# cart(["apple"] + "pear")         # 문자열
# cart([:apple] + :pear)           # atom
# cart(["apple", "banana"] + "orange")

# MacroExample.cart ["apple"] + "pear"
# MacroExample.cart [:apple] + :pear
# MacroExample.cart ["apple", "banana"] + "orange"
