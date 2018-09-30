# Asm

This is aimed at implementing an inline assembler.

Currently, it provides the following:

* `is_int64` macro that can be used in `when` clauses to judge that a value is within INT64.

* `max_int` is the constant value of maxium of INT64.

* `min_int` is the constant value of minimum of INT64.

* `max_uint` is the constant value of maxium of UINT64.

* `min_uint` is the constant value of minimum of UINT64.

`BigNum` module is also provided. This module is used for passing an integer by BigNum from/to NIF.

## Installation

The package can be installed
by adding `asm` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:asm, "~> 0.0.9"}
  ]
end
```

## Usage

```elixir
defmodule Foo do
	require Asm
	import Asm
	def add(a, b) when is_int64(a) and is_int64(b) do
		a + b
	end
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/asm](https://hexdocs.pm/asm).

