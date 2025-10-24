defmodule MyApp.PersonValidator do
  @moduledoc """
  공식 문서의 PersonValidator 예제

  https://hexdocs.pm/spark/get-started-with-spark.html

  ## 사용 예제

  ```elixir
  # 성공 케이스
  MyApp.PersonValidator.validate(%{name: "Zach", email: " foo@example.com "})
  # {:ok, %{id: nil, name: "Zach", email: "foo@example.com"}}

  # 실패 케이스 - 잘못된 이메일
  MyApp.PersonValidator.validate(%{name: "Zach", email: " blank "})
  # {:error, :invalid, :email}

  # 실패 케이스 - 필수 필드 누락
  MyApp.PersonValidator.validate(%{email: "test@example.com"})
  # {:error, :missing_required_fields, [:name]}
  ```

  Note: Spark DSL 모듈은 컴파일 타임에 코드가 생성되므로
  doctest 대신 일반 ExUnit 테스트를 사용합니다.
  """

  use MyLibrary.Validator

  fields do
    required [:name]
    field :name, :string

    field :email, :string do
      check &String.contains?(&1, "@")
      transform &String.trim/1
    end

    # This syntax is also supported
    # field :email, :string, check: &String.contains?(&1, "@"), transform: &String.trim/1
  end
end
