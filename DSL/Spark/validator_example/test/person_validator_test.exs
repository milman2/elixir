defmodule PersonValidatorTest do
  use ExUnit.Case
  doctest MyApp.PersonValidator

  describe "PersonValidator" do
    test "validates correct data" do
      assert {:ok, result} = MyApp.PersonValidator.validate(%{name: "Zach", email: " foo@example.com "})
      assert result.name == "Zach"
      assert result.email == "foo@example.com"  # trimmed
      assert result.id == nil  # added by transformer
    end

    test "rejects invalid email (no @)" do
      assert {:error, :invalid, :email} = MyApp.PersonValidator.validate(%{name: "Zach", email: " blank "})
    end

    test "rejects missing required field" do
      assert {:error, :missing_required_fields, [:name]} =
        MyApp.PersonValidator.validate(%{email: "test@example.com"})
    end

    test "allows optional email field to be omitted" do
      assert {:ok, result} = MyApp.PersonValidator.validate(%{name: "Zach"})
      assert result.name == "Zach"
      assert result.email == nil
      assert result.id == nil
    end

    test "id field is automatically added by transformer" do
      fields = MyLibrary.Validator.Info.fields(MyApp.PersonValidator)
      field_names = Enum.map(fields, & &1.name)

      assert :id in field_names
      assert :name in field_names
      assert :email in field_names
    end

    test "Info module provides convenient access" do
      assert is_list(MyLibrary.Validator.Info.fields(MyApp.PersonValidator))
      assert MyLibrary.Validator.Info.fields_required!(MyApp.PersonValidator) == [:name]
    end
  end
end
