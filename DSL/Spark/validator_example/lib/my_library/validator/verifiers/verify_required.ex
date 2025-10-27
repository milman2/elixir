defmodule MyLibrary.Validator.Verifiers.VerifyRequired do
  @moduledoc """
  Verifier that ensures all required fields are also defined in the fields section

  공식 문서 예제: https://hexdocs.pm/spark/get-started-with-spark.html#verifiers
  """

  use Spark.Dsl.Verifier
  # verify/1

  # dsl_state here is a map of the underlying DSL data
  def verify(dsl_state) do
    # we can use our info module here, even though we are passing in a
    # map of data and not a module! Very handy.

    required = MyLibrary.Validator.Info.fields_required!(dsl_state)
    fields = Enum.map(MyLibrary.Validator.Info.fields(dsl_state), & &1.name)

    if Enum.all?(required, &Enum.member?(fields, &1)) do
      :ok
    else
      {:error,
       Spark.Error.DslError.exception(
         message: "All required fields must be specified in fields",
         path: [:fields, :required],
         # this is how you get the original module out.
         # only do this for display purposes.
         # the module is not yet compiled (we're compiling it right now!), so if you
         # try to call functions on it, you will deadlock the compiler
         # and get an error
         module: Spark.Dsl.Verifier.get_persisted(dsl_state, :module)
       )}
    end
  end
end
