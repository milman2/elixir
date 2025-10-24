defmodule MyDsl do
  @moduledoc """
  간단한 Spark DSL 예제 (공식 문서 기준)

  ## 사용법

      defmodule MyApp.MyFeature do
        use MyDsl

        config do
          foo "hello"
          bar 99
        end
      end

  ## 설정 조회

      # Extension을 통해
      Spark.Dsl.Extension.get_entities(MyApp.MyFeature, [:config])

      # Info 모듈을 통해 (더 편리)
      MyDsl.Info.config(MyApp.MyFeature)
      MyDsl.Info.config_foo(MyApp.MyFeature)
  """

  use Spark.Dsl,
    default_extensions: [
      extensions: [MyDsl.Extension]
    ]
end
