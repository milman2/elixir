# Spark DSL 핵심 가이드

이 문서는 Spark DSL이 제공하는 주요 기능들을 설명합니다.

> 공식 문서: https://hexdocs.pm/spark/get-started-with-spark.html

## 왜 Spark를 사용하나요?

**커스텀 매크로의 한계:**
- ❌ 타입 검증 없음
- ❌ 문서 자동 생성 없음
- ❌ Introspection 어려움
- ❌ 컴파일 타임 최적화 불가
- ❌ 확장성 낮음

**Spark가 해결하는 문제:**
- ✅ 선언적 DSL 정의
- ✅ 자동 타입 검증
- ✅ 자동 문서화
- ✅ 강력한 Introspection
- ✅ Transformers & Verifiers
- ✅ 높은 확장성

---

## Spark DSL 핵심 기능

### Spark가 제공하는 기능

#### 🔍 1. 자동 타입 검증
```elixir
# Extension 정의
schema: [
  foo: [type: :string, required: true],
  bar: [type: :integer, default: 42]
]

# 사용 시
config foo: "hello", bar: "wrong"  # 컴파일 에러!
# ** (Spark.Error.DslError) Expected :bar to be integer, got: "wrong"
```

#### 📚 2. 자동 문서 생성
```elixir
# Extension에서 정의
schema: [
  foo: [
    type: :string,
    required: true,
    doc: "A required string configuration"  # 자동으로 문서화됨
  ]
]

# IEx에서
h MyDsl  # 자동 생성된 문서 표시
```

#### 🔎 3. Introspection (구조 쿼리)
```elixir
# 런타임에 DSL 정보 조회
Spark.Dsl.Extension.get_entities(MyApp.MyFeature, [:settings])
Spark.Dsl.Extension.get_persisted(MyApp.MyFeature, :config)

# 모든 옵션 확인
Spark.Dsl.Extension.get_opt(MyApp.MyFeature, :foo)
```

#### ⚡ 4. Transformers (컴파일 타임 변환)
```elixir
defmodule MyTransformer do
  use Spark.Dsl.Transformer
  
  def transform(dsl_state) do
    # 컴파일 타임에 DSL을 분석하고 변환
    # 예: 최적화, 검증, 코드 생성 등
    {:ok, dsl_state}
  end
end
```

#### 📦 5. Extension 조합
```elixir
defmodule MyDsl do
  use Spark.Dsl,
    default_extensions: [
      extension: MyDsl.Extension1,
      plugin: MyDsl.Extension2,
      validator: MyDsl.Extension3
    ]
end

# 여러 Extension을 조합하여 복잡한 DSL 구성 가능
```

#### 🎯 6. Entity와 Section
```elixir
# Entity: 반복 가능한 DSL 구조
config foo: "one"
config foo: "two"  # 여러 개 정의 가능

# Section: DSL 구조 조직화
my_section do
  config foo: "hello"
  
  nested_section do
    option bar: 123
  end
end
```

---

## 언제 Spark를 사용해야 하나요?

### Spark가 적합한 경우
- ✅ 복잡한 DSL (많은 옵션과 중첩 구조)
- ✅ 프레임워크/라이브러리 개발
- ✅ 타입 안정성이 중요할 때
- ✅ 자동 문서화가 필요할 때
- ✅ 플러그인 시스템이 필요할 때
- ✅ 컴파일 타임 검증/변환이 필요할 때

### 대안 (커스텀 매크로)이 나을 수 있는 경우
- 간단한 DSL (< 5개 옵션)
- 빠른 프로토타입
- 의존성 최소화가 중요할 때
- 학습/교육 목적

---

## 실제 사용 예: Ash Framework

```elixir
defmodule MyApp.Post do
  use Ash.Resource,
    data_layer: Ash.DataLayer.Ets
  
  attributes do
    uuid_primary_key :id
    attribute :title, :string, allow_nil?: false
    attribute :body, :string
    create_timestamp :created_at
  end
  
  actions do
    defaults [:create, :read, :update, :destroy]
  end
  
  relationships do
    belongs_to :author, MyApp.Author
    has_many :comments, MyApp.Comment
  end
end
```

위 코드는 모두 Spark DSL로 구현되어:
- ✅ 타입 검증
- ✅ 자동 문서화
- ✅ 런타임 Introspection
- ✅ 컴파일 타임 Transformation
- ✅ 확장 가능한 구조

를 제공합니다.

---

## 결론

**Spark의 핵심 가치:**

1. **선언적 DSL 정의**
   - 매크로를 직접 작성하지 않고 구조만 선언
   - Section, Entity, Schema로 DSL 구조 정의

2. **타입 안정성**
   - 컴파일 타임 타입 검증
   - 잘못된 값 사용 시 명확한 에러 메시지

3. **자동화된 개발 경험**
   - InfoGenerator로 편리한 API 자동 생성
   - 문서 자동 생성
   - 에디터 지원 (elixir_sense 플러그인)

4. **확장성과 조합성**
   - Extension을 조합하여 복잡한 DSL 구성
   - Transformer로 컴파일 타임 최적화
   - Verifier로 검증 로직 추가

**학습 권장 순서:**

1. **이 프로젝트의 예제 이해하기**
   - `lib/my_dsl_extension.ex` - Extension 정의 방법
   - `lib/my_dsl.ex` - DSL 모듈 설정
   - `lib/my_dsl_info.ex` - InfoGenerator 사용
   - `lib/my_app.ex` - 실제 사용 예제

2. **공식 문서 읽기**
   - https://hexdocs.pm/spark/get-started-with-spark.html
   - Section, Entity, Transformer, Verifier 개념 이해

3. **Ash Framework 연구**
   - https://github.com/ash-project/ash
   - Spark의 실전 활용 사례
   - 복잡한 DSL 구조 학습

4. **자신만의 DSL 만들기**
   - 실제 문제에 Spark 적용
   - Extension 확장 및 조합

