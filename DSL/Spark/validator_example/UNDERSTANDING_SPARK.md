# Spark 이해하기 (초보자용)

## 🎯 Spark를 한 문장으로

**"Spark = DSL 만드는 레고 블록"**

---

## 📚 단계별 이해

### 1단계: Entity (한 덩어리)

**실제 사용:**
```elixir
field :name, :string
```

**Entity 정의:** (`lib/my_library/validator/dsl.ex`)
```elixir
@field %Spark.Dsl.Entity{
  name: :field,           # ← "field" 매크로 이름
  args: [:name, :type],   # ← 필수 인자 2개
  target: Field,          # ← 데이터를 저장할 구조체
  schema: [               # ← 추가 옵션들
    check: [type: {:fun, 1}],
    transform: [type: {:fun, 1}]
  ]
}
```

**이해:**
- `field :name, :string` 하나가 → `%Field{name: :name, type: :string}` 구조체가 됨
- Spark가 자동으로 `field` 매크로 생성
- 타입 검증도 자동

---

### 2단계: Section (그룹)

**실제 사용:**
```elixir
fields do
  required [:name]
  field :name, :string
  field :email, :string
end
```

**Section 정의:**
```elixir
@fields %Spark.Dsl.Section{
  name: :fields,              # ← "fields" 블록 이름
  entities: [@field],         # ← 사용 가능한 Entity
  schema: [                   # ← Section 자체 옵션
    required: [
      type: {:list, :atom},
      default: []
    ]
  ]
}
```

**이해:**
- `fields do ... end` 블록 생성
- 안에서 `field` 여러 개 사용 가능
- `required` 옵션도 사용 가능

---

### 3단계: Extension (전체 DSL)

**Extension 정의:**
```elixir
use Spark.Dsl.Extension,
  sections: [@fields],          # ← Section들
  transformers: [               # ← 컴파일 타임 변환
    MyLibrary.Validator.Transformers.AddId,
    MyLibrary.Validator.Transformers.GenerateValidate
  ],
  verifiers: [                  # ← 검증
    MyLibrary.Validator.Verifiers.VerifyRequired
  ]
```

**이해:**
- 모든 것을 하나로 묶음
- Transformer, Verifier 등록

---

## 🔄 실행 흐름 (예제로)

### 사용자가 작성:
```elixir
defmodule MyApp.PersonValidator do
  use MyLibrary.Validator

  fields do
    required [:name]
    field :name, :string
    field :email, :string
  end
end
```

### 1️⃣ Spark가 파싱 (컴파일 시작)

```
fields do
  required [:name]           → Section 옵션: %{required: [:name]}
  field :name, :string       → Entity: %Field{name: :name, type: :string}
  field :email, :string      → Entity: %Field{name: :email, type: :string}
end
```

### 2️⃣ Transformer: AddId 실행

```
Before: [:name, :email]
After:  [:id, :name, :email]  ← :id 자동 추가!
```

**코드:** (`lib/my_library/validator/transformers/add_id.ex`)
```elixir
def transform(dsl_state) do
  {:ok, Spark.Dsl.Transformer.add_entity(
    dsl_state, 
    [:fields], 
    %Field{name: :id, type: :string}
  )}
end
```

### 3️⃣ Verifier: VerifyRequired 검증

```
required에 [:name] 있음
fields에 [:id, :name, :email] 있음
[:name] ⊆ [:id, :name, :email] ✅ 통과!
```

### 4️⃣ Transformer: GenerateValidate 실행

모듈에 이 코드 자동 생성:
```elixir
def validate(data) do
  MyLibrary.Validator.validate(__MODULE__, data)
end
```

### 5️⃣ 컴파일 완료!

이제 사용 가능:
```elixir
MyApp.PersonValidator.validate(%{name: "Zach", email: "test@example.com"})
```

---

## 🎨 비유로 이해

### 레고 비유

1. **Entity** = 레고 블록 (작은 조각)
   ```
   field :name, :string  ← 빨간 블록 하나
   ```

2. **Section** = 레고 판 (블록들을 올려놓는 곳)
   ```
   fields do
     field :name, :string    ← 블록 1
     field :email, :string   ← 블록 2
   end
   ```

3. **Extension** = 완성된 레고 세트 (조립 설명서)
   ```
   "이렇게 조립하면 Validator가 됩니다!"
   ```

4. **Transformer** = 자동 조립 로봇
   ```
   "자동으로 :id 블록 추가해드립니다!"
   ```

5. **Verifier** = 품질 검사원
   ```
   "required 필드 다 있나요? 확인!"
   ```

---

## 💻 직접 확인해보기

### 1. IEx 실행
```bash
cd /home/milman2/elixir/DSL/Spark/validator_example
iex -S mix
```

### 2. 구조 확인
```elixir
# Entity들 보기
iex> MyLibrary.Validator.Info.fields(MyApp.PersonValidator)
[
  %MyLibrary.Validator.Dsl.Field{name: :id, ...},      # ← Transformer가 추가!
  %MyLibrary.Validator.Dsl.Field{name: :name, ...},
  %MyLibrary.Validator.Dsl.Field{name: :email, ...}
]

# Section 옵션 보기
iex> MyLibrary.Validator.Info.fields_required!(MyApp.PersonValidator)
[:name]
```

### 3. 자동 생성된 함수 사용
```elixir
# GenerateValidate Transformer가 만든 함수
iex> MyApp.PersonValidator.validate(%{name: "Test", email: "a@b.com"})
{:ok, %{id: nil, name: "Test", email: "a@b.com"}}
```

---

## 🤔 자주 하는 질문

### Q1: Entity vs Section 차이?

**Entity** = 반복 가능
```elixir
field :name, :string
field :email, :string    # ← 여러 개 OK
```

**Section** = 한 번만
```elixir
fields do ... end
fields do ... end        # ← 에러! 한 번만 가능
```

### Q2: Transformer vs Verifier 차이?

**Transformer** = 변경 가능
```elixir
# :id 필드를 추가할 수 있음
Spark.Dsl.Transformer.add_entity(...)
```

**Verifier** = 검증만
```elixir
# 통과 or 에러만 가능, 변경 불가
if valid?, do: :ok, else: {:error, ...}
```

### Q3: 왜 이렇게 복잡해?

**간단한 DSL** → 매크로 직접 작성 (OK)

**복잡한 DSL** → Spark 사용 (필수!)
- Ash Framework 같은 거 만들려면 Spark 필요
- 타입 검증, 문서화, 확장성 모두 자동

---

## 📝 핵심 정리

### Spark의 마법 3단계

1. **선언만 하면** (Entity, Section 정의)
2. **Spark가 만들어주고** (매크로 자동 생성)
3. **추가 기능 공짜** (타입 검증, 문서화, Info 모듈)

### 기억해야 할 것

```
Entity (덩어리)
  ↓
Section (그룹)
  ↓
Extension (전체)
  ↓
Transformer (변환) + Verifier (검증)
  ↓
완성! 🎉
```

---

## 🎓 학습 순서

1. ✅ **Entity 이해** - `@field` 정의 보기
2. ✅ **Section 이해** - `@fields` 정의 보기
3. ✅ **사용 예제** - `person_validator.ex` 보기
4. ✅ **Transformer** - `add_id.ex` 보기
5. ✅ **Verifier** - `verify_required.ex` 보기
6. ✅ **테스트** - `mix test` 실행
7. ✅ **IEx로 확인** - 직접 써보기

---

## 🔗 다음 단계

1. **간단한 DSL 만들어보기**
   - Entity 1개
   - Section 1개
   - Extension 정의

2. **Transformer 추가**
   - 자동으로 뭔가 추가하기

3. **Verifier 추가**
   - 검증 로직 추가

4. **InfoGenerator 사용**
   - 편리한 함수 자동 생성

---

이제 Spark가 좀 더 이해되시나요? 😊

핵심은: **"Spark = 매크로를 자동으로 만들어주는 도구"**

