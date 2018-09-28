defmodule Foo do
  require OK
  require Asm
  import Asm
  def addi(a, b) when is_int64(a) and is_int64(b) do
    a + b
  end

  def addu(a, b) when is_uint64(a) and is_uint64(b) do
    a + b
  end

  def addb(a, b) when is_bignum(a) and is_bignum(b) do
    a + b
  end

  def adda(a, b) do
    asm do: add a, b
  end

  def asm_1_nif_ii(a, b) when is_int64(a)  and is_int64(b),  do: a + b

end

defmodule AsmTest do
  use ExUnit.Case
  doctest Asm
  require Asm

  test "addi" do
  	assert Foo.addi(1, 2) == 3
  end

  test "addu" do
    assert Foo.addu(1, 2) == 3
  end

  test "addb" do
    assert Foo.addb(Asm.max_uint + 1, Asm.min_int - 1) == Asm.max_uint + Asm.min_int
  end

  test "asm do: add a, b" do
    assert Foo.adda(1, 2) == [3] # 仮
  end
end

