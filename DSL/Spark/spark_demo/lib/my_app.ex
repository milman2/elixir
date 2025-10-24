defmodule MyApp.MyFeature do
  @moduledoc """
  MyDsl을 사용하는 예제 모듈 (공식 문서 기준)
  """

  use MyDsl

  config do
    foo "hello from Spark DSL"
    bar 99
  end
end
