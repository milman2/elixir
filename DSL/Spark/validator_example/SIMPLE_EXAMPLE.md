# Spark 초간단 예제 (비교하며 이해하기)

## 🎯 같은 기능, 두 가지 방법

### ❌ 매크로 직접 작성 (어려운 방법)

```elixir
defmodule HardWay do
  defmacro __using__(_opts) do
    quote do
      import HardWay
      Module.register_attribute(__MODULE__, :fields, accumulate: true)
      @before_compile HardWay
    end
  end

  defmacro field(name, type) do
    quote do
      @fields {unquote(name), unquote(type)}
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def get_fields do
        @fields |> Enum.reverse()
      end
    end
  end
end

# 사용
defmodule MyValidator do
  use HardWay
  
  field :name, :string
  field :email, :string
end

MyValidator.get_fields()
# [name: :string, email: :string]
```

**문제점:**
- 😰 매크로 복잡
- ❌ 타입 검증 없음
- ❌ 문서화 없음
- ❌ 확장 어려움

---

### ✅ Spark 사용 (쉬운 방법)

#### 1️⃣ Extension 정의 (한 번만)

```elixir
defmodule EasyWay.Extension do
  @field %Spark.Dsl.Entity{
    name: :field,
    args: [:name, :type],
    target: EasyWay.Field,
    schema: [
      name: [type: :atom, required: true],
      type: [type: :atom, required: true]
    ]
  }

  @fields %Spark.Dsl.Section{
    name: :fields,
    entities: [@field]
  }

  use Spark.Dsl.Extension, sections: [@fields]
end

defmodule EasyWay.Field do
  defstruct [:name, :type, :__spark_metadata__]
end
```

#### 2️⃣ DSL 모듈 정의

```elixir
defmodule EasyWay do
  use Spark.Dsl,
    default_extensions: [extensions: [EasyWay.Extension]]
end
```

#### 3️⃣ Info 모듈 (자동 함수 생성)

```elixir
defmodule EasyWay.Info do
  use Spark.InfoGenerator,
    extension: EasyWay.Extension,
    sections: [:fields]
end
```

#### 4️⃣ 사용

```elixir
defmodule MyValidator do
  use EasyWay
  
  fields do
    field :name, :string
    field :email, :string
  end
end

# Info 모듈이 자동으로 만들어준 함수들
EasyWay.Info.fields(MyValidator)
# [%EasyWay.Field{name: :name, type: :string}, ...]
```

**장점:**
- 😊 매크로 작성 안 함
- ✅ 타입 검증 자동
- ✅ 문서화 자동
- ✅ 확장 쉬움

---

## 📊 비교표

| 기능 | 매크로 직접 작성 | Spark 사용 |
|-----|---------------|-----------|
| 매크로 작성 | 필요 (복잡) | 불필요 (선언만) |
| 타입 검증 | 직접 구현 | 자동 |
| 문서화 | 직접 작성 | 자동 |
| Info 함수 | 직접 구현 | 자동 생성 |
| 에러 메시지 | 직접 구현 | 자동 |
| 확장성 | 어려움 | 쉬움 |
| 학습 곡선 | 가파름 | 완만함 |

---

## 🔍 Spark의 3단계만 기억하세요!

### 1단계: Entity 선언
```elixir
@field %Spark.Dsl.Entity{
  name: :field,           # 이름
  args: [:name, :type]    # 인자
}
```
→ `field :name, :string` 매크로 자동 생성!

### 2단계: Section 선언
```elixir
@fields %Spark.Dsl.Section{
  name: :fields,
  entities: [@field]
}
```
→ `fields do ... end` 블록 자동 생성!

### 3단계: Extension 등록
```elixir
use Spark.Dsl.Extension, sections: [@fields]
```
→ 모든 것 연결 완료!

---

## 💡 핵심 이해

### Spark가 하는 일

```
당신이 작성:
  @field %Spark.Dsl.Entity{...}
  
Spark가 생성:
  defmacro field(name, type) do
    # 100줄의 복잡한 코드
  end
```

**즉, Spark = 매크로 자동 생성기**

---

## 🎮 직접 해보기

### 실행
```bash
cd /home/milman2/elixir/DSL/Spark/validator_example
iex -S mix
```

### 테스트
```elixir
# 1. 필드 목록 확인
iex> MyLibrary.Validator.Info.fields(MyApp.PersonValidator)

# 2. 검증 실행
iex> MyApp.PersonValidator.validate(%{name: "Test", email: "a@b.com"})

# 3. 에러 테스트
iex> MyApp.PersonValidator.validate(%{name: "Test", email: "no-at"})
```

---

## 🎯 결론

**Spark를 한 줄로:**
> "매크로를 레고처럼 조립하는 도구"

**사용하는 이유:**
> "복잡한 DSL을 쉽게 만들기 위해"

**핵심 3가지:**
1. Entity (덩어리)
2. Section (그룹)
3. Extension (전체)

이것만 알면 Spark의 80%를 이해한 것입니다! 🎉

