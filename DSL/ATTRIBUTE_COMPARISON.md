# @attribute vs Module.put_attribute 비교

> 📖 **관련 문서:** Schema DSL 구현 예제는 [SCHEMA_DSL_README.md](./SCHEMA_DSL_README.md)를 참고하세요.

---

## 🎯 핵심 차이 (한 문장 요약)

| 방법 | 매크로 `quote` 블록 안에서 |
|-----|-------------------------|
| `@attribute value` | **매크로 정의 모듈**에 설정 ❌ |
| `Module.put_attribute(__MODULE__, ...)` | **매크로 호출 모듈**에 설정 ✅ |

---

## 📝 예제: 매크로 안에서 (차이 발생!)

### ❌ 잘못된 방법: `@attribute` 사용

```elixir
defmodule WrongDSL do
  defmacro set_config(key, value) do
    quote do
      @config {unquote(key), unquote(value)}
    end
  end
end

defmodule MyApp do
  import WrongDSL
  set_config :name, "MyApp"
end

# 문제: @config가 WrongDSL에 설정됨!
# MyApp에는 설정되지 않음
```

### ✅ 올바른 방법: `Module.put_attribute` 사용

```elixir
defmodule CorrectDSL do
  defmacro set_config(key, value) do
    quote do
      Module.put_attribute(__MODULE__, :config, {unquote(key), unquote(value)})
    end
  end
end

defmodule MyApp do
  import CorrectDSL
  set_config :name, "MyApp"
end

# ✅ @config가 MyApp에 설정됨!
```

---

## 💡 왜 `Module.put_attribute`가 작동하는가?

**핵심:** `quote` 블록 안의 `__MODULE__`은 **매크로를 호출하는 모듈**을 가리킵니다!

```elixir
defmodule MyDSL do
  defmacro my_macro do
    quote do
      __MODULE__  # ← 이건 MyDSL이 아니라 호출하는 모듈!
    end
  end
end

defmodule MyApp do
  import MyDSL
  my_macro  # __MODULE__ = MyApp
end
```

---

## 🎯 언제 무엇을 사용?

| 상황 | 사용 방법 | 이유 |
|-----|---------|-----|
| 모듈 최상위에서 직접 설정 | `@attribute value` | 간단하고 명확 |
| 매크로 `quote` 블록 안 | `Module.put_attribute` | 호출 모듈에 설정 ✅ |
| 동적 attribute 이름 | `Module.put_attribute` | 유일한 방법 |
| 함수/조건문 안에서 설정 | `Module.put_attribute` | `@`는 불가능 |

---

## 📚 핵심 정리

> **DSL 매크로를 만들 때는 항상 `Module.put_attribute`를 사용하세요!**

**이유:**
1. `quote` 블록의 코드는 **매크로를 호출하는 모듈**에서 실행됨
2. `__MODULE__`이 호출 모듈을 가리키므로, `Module.put_attribute`가 올바른 곳에 설정됨
3. DSL의 목적은 **사용자 모듈**에 데이터를 저장하는 것

---

## 🔗 참고 자료

- [Module Attributes](https://elixir-lang.org/getting-started/module-attributes.html)
- [Module.put_attribute/3](https://hexdocs.pm/elixir/Module.html#put_attribute/3)
- [Metaprogramming Guide](https://elixir-lang.org/getting-started/meta/quote-and-unquote.html)

