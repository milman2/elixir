# [Spark](https://deepwiki.com/ash-project/spark/1-spark-overview)
## Documentation and Tooling
- Spark.InfoGenerator
- Spark.CheatSheet
- Spark.Formatter
- Spark.Igniter
## Options System
- Spark.Options
    - Spark.Options.Validator
    - Spark.Options.Helpers
## Core DSL Framework    
- Spark.Dsl
    - Spark.Dsl.Fragment
    - Spark.Dsl.Extension
        - Spark.Dsl.Section
        - Spark.Dsl.Entity
        - Spark.Dsl.Tranformer
        - Spark.Dsl.Verifier
# install
```elixir
def deps do
    [
        {:spark, "~> 2.2"}
    ]
end
```

```shell
mix deps.get
```

# Set up the Spark formatter
```shell
mix spark.install
```
- .formatter.exs
```elixir
[
    plugins: [Spark.Formatter],
    # ... other formatter configuration
]
```

# Configuration Options
## Formatter Options
- remove_paren?
- features
## DSL Behavior Options
- enforce_spark_elixir_sense_behaviours?

```elixir
# In config/config.exs
config :spark, :formatter,
    remove_paren?: true
config :spark, :enforce_spark_elixir_sense_behaviours?, true    
```

# Optional Dependencies
- sourceror : Source code manipulation and AST processing
    - Parsing DSL syntax
    - Generating formatted code
    - Handling code transformations
- jason : JSON encoding/decoding
    - Serializing configuration data
    - Working with JSON-formatted documentation
- igniter : DSL patching and enhancement
    - Providing patching capabilities for DSLs
    - Extend existing DSL functionality
    - Support more flexible DSL composition
```elixir
# mix.exs
{:sourceror, "~> 1.8", only: [:dev, :test]},
{:jason, "~> 1.4"},
{:igniter, "~> 0.2 and >= 0.3.64"}
```

# IDE Integration
```elixir
{:elixir_sense, github: "elixir-lsp/elixir_sense", only: [:dev, :test]}
```

# Additional Tooling
```shell
mix spark.install
mix spark.formatter
mix sparkk.cheat_sheets
```

# Option System - types
## Basic Types
- :any, :atom, :string, :boolean, :integer, :non_neg_integer, :pos_integer, :float, :timeout, :pid, :reference, nil
## Function Types
- :fun, {:fun, arity}, {:fun, args_types}, {:fun, args_types, return_type}
## Collection Types
- :keyword_list / :non_empty_keyword_list
- {:keyword_lsit, schema} / {:non_empty_keyword_list, schema}
- :map / {:map, key_type, value_type}
- {:list, subtype}
- {:tuple, list_of_subtypes}
- {:wrap_list, type}
## Elixir-Specific Types
- :mfa, :mod_arg, {:struct, struct_name}, :struct
## Validation Types
- {:in choices} / {:one_of, choices}
- {:or subtypes}
- {:custom, mod, fun, args}
## Spark-Specific Types
- {:spark_behaviour, behaviour}
- {:behaviour, behaviour}
- {:protocol, protocol}
- {:impl, protocol}
- {:spark, dsl_module}
## Other Types
- {:tagged_tuple, tag, inner_type}
- :literal / {:literal, value}
- :quoted

