# Validator Example - Spark 공식 문서 예제

Spark 공식 문서의 전체 예제를 실제로 작동하도록 구현한 프로젝트입니다.

> 공식 문서: https://hexdocs.pm/spark/get-started-with-spark.html

## 🎯 프로젝트 목적

Spark 공식 문서의 Validator DSL 예제를 완전하게 구현하여:
- Section과 Entity 사용법 이해
- Transformer (컴파일 타임 변환) 실습
- Verifier (검증 로직) 실습
- InfoGenerator 사용법 습득
- 실제 작동하는 DSL 경험

## 📁 파일 구조

```
lib/
├── my_library/
│   └── validator/
│       ├── dsl.ex                          # Extension 정의 (Section, Entity)
│       ├── info.ex                         # InfoGenerator
│       ├── transformers/
│       │   ├── add_id.ex                   # ID 필드 자동 추가
│       │   └── generate_validate.ex        # validate/1 함수 생성
│       └── verifiers/
│           └── verify_required.ex          # 필수 필드 검증
├── my_library/
│   └── validator.ex                        # DSL 모듈 + validate 구현
└── my_app/
    └── person_validator.ex                 # 사용 예제

test/
└── person_validator_test.exs               # 8 tests pass!
```

## 🚀 빠른 시작

### 1. 의존성 설치
```bash
cd /home/milman2/elixir/DSL/Spark/validator_example
mix deps.get
```

### 2. 컴파일
```bash
mix compile
```

### 3. 테스트 실행 ✅
```bash
mix test
# 8 tests, 0 failures
```

## 💡 예제 실행

### 터미널에서 실행
```bash
mix run -e "
result = MyApp.PersonValidator.validate(%{name: \"Zach\", email: \" foo@example.com \"})
IO.inspect(result)
"
# {:ok, %{id: nil, name: "Zach", email: "foo@example.com"}}
```

### IEx에서 실행
```bash
iex -S mix
```

```elixir
# ✅ 성공 케이스
iex> MyApp.PersonValidator.validate(%{name: "Zach", email: " foo@example.com "})
{:ok, %{id: nil, name: "Zach", email: "foo@example.com"}}

# ❌ 실패 케이스 (invalid email)
iex> MyApp.PersonValidator.validate(%{name: "Zach", email: " blank "})
{:error, :invalid, :email}

# 📋 Info 모듈 사용
iex> MyLibrary.Validator.Info.fields(MyApp.PersonValidator)
[
  %MyLibrary.Validator.Dsl.Field{name: :id, type: :string, ...},
  %MyLibrary.Validator.Dsl.Field{name: :name, type: :string, ...},
  %MyLibrary.Validator.Dsl.Field{name: :email, type: :string, ...}
]

iex> MyLibrary.Validator.Info.fields_required!(MyApp.PersonValidator)
[:name]
```

## 📚 핵심 개념

### 1. Extension 정의 (lib/my_library/validator/dsl.ex)

```elixir
# Entity: 반복 가능한 DSL 구조
@field %Spark.Dsl.Entity{
  name: :field,
  args: [:name, :type],
  target: Field,
  schema: [
    name: [type: :atom, required: true],
    type: [type: {:in, [:integer, :string]}, required: true],
    check: [type: {:fun, 1}],
    transform: [type: {:fun, 1}]
  ]
}

# Section: Entity들을 그룹화
@fields %Spark.Dsl.Section{
  name: :fields,
  entities: [@field],
  schema: [
    required: [type: {:list, :atom}, default: []]
  ]
}
```

### 2. Transformer: 컴파일 타임 변환

```elixir
defmodule MyLibrary.Validator.Transformers.AddId do
  use Spark.Dsl.Transformer

  def transform(dsl_state) do
    # :id 필드를 모든 validator에 자동 추가
    {:ok, Spark.Dsl.Transformer.add_entity(dsl_state, [:fields], 
      %MyLibrary.Validator.Dsl.Field{name: :id, type: :string})}
  end
end
```

### 3. Verifier: 검증 로직

```elixir
defmodule MyLibrary.Validator.Verifiers.VerifyRequired do
  use Spark.Dsl.Verifier

  def verify(dsl_state) do
    required = MyLibrary.Validator.Info.fields_required!(dsl_state)
    fields = Enum.map(MyLibrary.Validator.Info.fields(dsl_state), & &1.name)

    if Enum.all?(required, &Enum.member?(fields, &1)) do
      :ok
    else
      {:error, Spark.Error.DslError.exception(
        message: "All required fields must be specified in fields"
      )}
    end
  end
end
```

### 4. InfoGenerator: 편리한 API

```elixir
defmodule MyLibrary.Validator.Info do
  use Spark.InfoGenerator, 
    extension: MyLibrary.Validator.Dsl, 
    sections: [:fields]
end

# 자동 생성되는 함수들:
# - fields/1
# - fields_required/1
# - fields_required!/1
```

## 🔍 주요 특징

### ✅ 작동하는 기능들

1. **Entity 정의**
   - `field` Entity로 필드 정의
   - `args`로 위치 인자 지원
   - `schema`로 옵션 검증

2. **Section 정의**
   - `fields` Section으로 필드들 그룹화
   - `schema`로 Section 옵션 정의 (required)

3. **Transformer**
   - `:id` 필드 자동 추가
   - `validate/1` 함수 자동 생성

4. **Verifier**
   - 필수 필드 존재 여부 검증
   - 컴파일 타임 에러 메시지

5. **InfoGenerator**
   - `fields/1` - 모든 필드 조회
   - `fields_required!/1` - 필수 필드 조회

6. **타입 검증**
   - `:string`, `:integer` 타입 체크
   - `check` 함수로 커스텀 검증
   - `transform` 함수로 값 변환

## 📖 공식 문서 대응

| 공식 문서 섹션 | 파일 위치 | 설명 |
|---------------|---------|------|
| Defining the DSL extension | `lib/my_library/validator/dsl.ex` | Entity, Section 정의 |
| Defining the DSL module | `lib/my_library/validator.ex` | DSL 모듈 + validate 구현 |
| Getting information out of our DSL | `lib/my_library/validator/info.ex` | InfoGenerator |
| Transformers | `lib/my_library/validator/transformers/` | AddId, GenerateValidate |
| Verifiers | `lib/my_library/validator/verifiers/` | VerifyRequired |
| Generating code into the module | `transformers/generate_validate.ex` | validate/1 생성 |

## 🎓 학습 순서

1. **`lib/my_app/person_validator.ex`** - DSL 사용 예제 보기
2. **`lib/my_library/validator/dsl.ex`** - Extension 구조 이해
3. **`test/person_validator_test.exs`** - 동작 확인
4. **Transformer & Verifier** - 고급 기능 학습
5. **`lib/my_library/validator.ex`** - validate 구현 로직

## 🔗 참고 자료

- [Spark 공식 문서](https://hexdocs.pm/spark/get-started-with-spark.html)
- [Spark GitHub](https://github.com/ash-project/spark)
- [Ash Framework](https://github.com/ash-project/ash) - Spark 실전 활용

## ✨ 핵심 포인트

1. **Entity는 반복 가능한 DSL 구조**를 정의
2. **Section은 Entity들을 그룹화**하고 자체 옵션을 가질 수 있음
3. **Transformer는 컴파일 타임에 DSL을 변환**
4. **Verifier는 최종 구조를 검증**
5. **InfoGenerator는 편리한 API를 자동 생성**
6. **함수를 DSL에서 정의 가능** (check, transform)

공식 문서의 모든 개념이 실제로 작동하는 것을 확인할 수 있습니다! 🎉
