# Asm

This is aimed at implementing an inline assembler.

Currently, it provides the `is_int64` macro that can be used in `when` clauses to judge that a value is within INT64.

## Installation

The package can be installed
by adding `asm` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:asm, "~> 0.0.1"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/asm](https://hexdocs.pm/asm).

