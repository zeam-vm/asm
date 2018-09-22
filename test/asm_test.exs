defmodule AsmTest do
  use ExUnit.Case
  doctest Asm

  test "greets the world" do
    assert Asm.hello() == :world
  end
end
