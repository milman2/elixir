defmodule MyDsl.Extension do
  @moduledoc """
  Spark DSL Extension - 공식 문서 기준 예제

  이 Extension은 MyDsl에서 사용할 수 있는 DSL 문법을 정의합니다.

  ## 참고
  - 공식 문서: https://hexdocs.pm/spark/get-started-with-spark.html
  - Spark는 Section의 schema를 사용하여 자동으로 설정을 처리합니다
  """

  @config %Spark.Dsl.Section{
    name: :config,
    describe: "Configuration options for MyDsl",
    schema: [
      foo: [
        type: :string,
        required: true,
        doc: "A required string configuration"
      ],
      bar: [
        type: :integer,
        default: 42,
        doc: "An optional integer configuration"
      ]
    ]
  }

  use Spark.Dsl.Extension, sections: [@config]
end
