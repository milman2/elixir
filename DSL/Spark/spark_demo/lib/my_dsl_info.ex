defmodule MyDsl.Info do
  @moduledoc """
  Info module for MyDsl

  Spark의 InfoGenerator를 사용하여 DSL 정보를 조회하는 함수들을 자동 생성합니다.

  ## 사용법

      # Section 전체 조회
      MyDsl.Info.config(MyApp.MyFeature)

      # 특정 옵션 조회 (returns {:ok, value} or :error)
      MyDsl.Info.config_foo(MyApp.MyFeature)

      # ! 버전은 값이 없으면 에러 발생
      MyDsl.Info.config_foo!(MyApp.MyFeature)

  ## 참고
  - 공식 문서: https://hexdocs.pm/spark/get-started-with-spark.html#getting-a-nice-interface-to-your-dsl
  """

  use Spark.InfoGenerator,
    extension: MyDsl.Extension,
    sections: [:config]
end
