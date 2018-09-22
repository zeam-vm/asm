defmodule AsmTest do
  use ExUnit.Case
  doctest Asm

  defmodule Foo do
  	require Asm
  	import Asm
  	def add(a, b) when is_int64(a) and is_int64(b) do
  		a + b
  	end
  end

  test "add" do
  	assert Foo.add(1, 2) == 3
  end
end
