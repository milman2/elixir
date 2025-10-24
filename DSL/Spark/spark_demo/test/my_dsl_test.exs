defmodule MyDslTest do
  use ExUnit.Case
  doctest MyDsl

  describe "Spark DSL" do
    test "Info module provides config_options" do
      assert MyDsl.Info.config_options(MyApp.MyFeature) == %{
        foo: "hello from Spark DSL",
        bar: 99
      }
    end

    test "Info module provides config_foo!" do
      assert MyDsl.Info.config_foo!(MyApp.MyFeature) == "hello from Spark DSL"
    end

    test "Info module provides config_bar!" do
      assert MyDsl.Info.config_bar!(MyApp.MyFeature) == 99
    end

    test "Extension API works with get_opt" do
      assert Spark.Dsl.Extension.get_opt(MyApp.MyFeature, [:config], :foo) == "hello from Spark DSL"
      assert Spark.Dsl.Extension.get_opt(MyApp.MyFeature, [:config], :bar) == 99
    end
  end

  describe "DSL usage" do
    defmodule TestValidator do
      use MyDsl

      config do
        foo "test value"
        bar 999
      end
    end

    test "can create new modules with MyDsl" do
      assert MyDsl.Info.config_foo!(TestValidator) == "test value"
      assert MyDsl.Info.config_bar!(TestValidator) == 999
    end

    test "default values work" do
      defmodule DefaultTest do
        use MyDsl

        config do
          foo "only foo"
        end
      end

      assert MyDsl.Info.config_foo!(DefaultTest) == "only foo"
      assert MyDsl.Info.config_bar!(DefaultTest) == 42  # default value
    end
  end
end
