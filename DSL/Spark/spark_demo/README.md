# Spark DSL 학습 프로젝트

Spark를 처음 접하는 사람을 위한 **실제로 작동하는** 예제 프로젝트입니다.

> 공식 문서: https://hexdocs.pm/spark/get-started-with-spark.html

## 📁 파일 구조

```
lib/
├── my_dsl.ex             # Spark DSL 정의
├── my_dsl_extension.ex   # Spark Extension 정의
├── my_dsl_info.ex        # Info 모듈 (자동 생성된 헬퍼 함수)
└── my_app.ex             # Spark DSL 사용 예제

test/
└── my_dsl_test.exs       # Spark DSL 테스트 (6 tests pass!)

SPARK_GUIDE.md            # Spark DSL 핵심 기능 가이드
```

## 🚀 빠른 시작

### 1. 의존성 설치
```bash
cd /home/milman2/elixir/DSL/Spark/spark_demo
mix deps.get
```

### 2. 컴파일
```bash
mix compile
```

### 3. 테스트 실행 ✅
```bash
mix test
# 6 tests, 0 failures
```

## 💡 예제 실행
```bash
# Info 모듈 사용
mix run -e "IO.inspect(MyDsl.Info.config_options(MyApp.MyFeature))"
# %{foo: "hello from Spark DSL", bar: 99}

# 개별 옵션 조회
mix run -e "IO.inspect(MyDsl.Info.config_foo!(MyApp.MyFeature))"
# "hello from Spark DSL"

# Extension API 사용
mix run -e "IO.inspect(Spark.Dsl.Extension.get_opt(MyApp.MyFeature, [:config], :foo))"
# "hello from Spark DSL"
```

### IEx에서 실행
```bash
iex -S mix
```

```elixir
# Info 모듈 사용 (추천!)
iex> MyDsl.Info.config_options(MyApp.MyFeature)
%{foo: "hello from Spark DSL", bar: 99}

iex> MyDsl.Info.config_foo!(MyApp.MyFeature)
"hello from Spark DSL"

iex> MyDsl.Info.config_bar!(MyApp.MyFeature)
99

# Spark DSL - Extension API
iex> Spark.Dsl.Extension.get_opt(MyApp.MyFeature, [:config], :foo)
"hello from Spark DSL"
```

## 📚 학습 자료

### Spark DSL 구조 ⭐
**공식 문서 기준으로 작동하는 예제!**

1. **`lib/my_dsl_extension.ex`** - Extension 정의
   - Section과 schema 정의
   - 타입 검증 설정
   - 기본값 설정

2. **`lib/my_dsl.ex`** - DSL 모듈
   - `default_extensions` 올바른 사용법
   - `extensions:` 키 필수!

3. **`lib/my_dsl_info.ex`** - Info 모듈
   - InfoGenerator 사용
   - 자동 생성된 헬퍼 함수들

4. **`lib/my_app.ex`** - 사용 예제
   - `config do ... end` 블록 사용

### 추가 학습 자료
**`SPARK_GUIDE.md`** - Spark DSL 핵심 가이드:
- Spark의 6가지 핵심 기능
- 실제 사용 사례 (Ash Framework)
- 언제 Spark를 사용해야 하는가
- 학습 권장 순서

## 💡 핵심 개념

### Spark DSL 사용법
```elixir
defmodule MyApp.MyFeature do
  use MyDsl

  config do
    foo "hello"
    bar 99
  end
end

# Info 모듈 사용 (추천!)
MyDsl.Info.config_foo!(MyApp.MyFeature)
# "hello"

# 타입 검증 자동!
config do
  foo "hello"
  bar "wrong"  # 컴파일 에러! integer 타입이어야 함
end
```

**Spark DSL의 장점:**
- ✅ 타입 안정성 (자동 검증)
- ✅ 자동 문서화
- ✅ InfoGenerator (편리한 API)
- ✅ Introspection
- ✅ Transformers와 Verifiers
- ✅ 확장 가능한 구조

## ✨ 주요 발견

### `default_extensions` 올바른 사용법
```elixir
# ❌ 잘못된 방법
use Spark.Dsl,
  default_extensions: [MyDsl.Extension]

# ✅ 올바른 방법 (공식 문서 기준)
use Spark.Dsl,
  default_extensions: [
    extensions: [MyDsl.Extension]  # extensions: 키 필수!
  ]
```

### Info 모듈의 자동 생성 함수들
```elixir
use Spark.InfoGenerator, 
  extension: MyDsl.Extension, 
  sections: [:config]

# 자동으로 생성되는 함수들:
# - config_options/1    # 모든 옵션 맵으로 반환
# - config_foo/1        # {:ok, value} or :error
# - config_foo!/1       # value or raise
# - config_bar/1
# - config_bar!/1
```

## 🎯 다음 단계

1. **Spark DSL 확장하기**
   - Entity 추가 (반복 가능한 구조)
   - Transformer 사용 (컴파일 타임 변환)
   - Verifier 추가 (검증 로직)

2. **Ash Framework 연구**
   - Spark의 실제 사용 사례
   - 복잡한 DSL 구조 이해
   - https://github.com/ash-project/ash

3. **자신만의 DSL 만들기**
   - 실제 문제에 적용
   - 필요에 따라 Spark 도입 검토

## 🔗 참고 자료

- [Spark 공식 문서](https://hexdocs.pm/spark/get-started-with-spark.html) ⭐
- [Spark GitHub](https://github.com/ash-project/spark)
- [Ash Framework](https://github.com/ash-project/ash) - Spark의 주요 사용자
- [Elixir 메타프로그래밍 가이드](https://elixir-lang.org/getting-started/meta/macros.html)

## 📝 중요 노트

✅ **Spark DSL이 제대로 작동합니다!**
- 공식 문서 기준으로 구현
- 6개 테스트 모두 통과
- Info 모듈로 편리한 조회 가능
- 타입 검증 자동 작동

**핵심 포인트:**
1. `default_extensions`는 `extensions:` 키가 필요
2. Section의 `schema`를 사용하면 자동으로 옵션 처리
3. InfoGenerator로 편리한 헬퍼 함수 자동 생성
4. `config do ... end` 블록 문법 지원
