defmodule Asm.BigNum do
  use Bitwise
  require Asm
  import Asm

  @moduledoc """
  Asm.BigNum is an implementation of BigNum for NIF interface.
  """
  defp is_negative(number) when number >= 0, do: 0
  defp is_negative(number) when number <  0, do: 1

  @doc """
  from_int(number) converts a number from integer to BigNum.

  ## Examples
  iex> Asm.BigNum.from_int(0)
  {0, [0]}

  iex> Asm.BigNum.from_int(Asm.max_uint + 1)
  {0, [1, 0]}

  iex> Asm.BigNum.from_int(-1)
  {1, [1]}

  iex> Asm.BigNum.from_int(-(Asm.max_uint + 1))
  {1, [1, 0]}
  """
  def from_int(number) when is_integer(number) do
    {number |> is_negative, number |> abs |> from_int_p}
  end

  defp from_int_p(number) when is_uint64(number), do: [number]
  defp from_int_p(number) when is_integer(number) do
    lower = number &&& Asm.max_uint
    higher = bsr(number, 64)
    from_int_p(higher) ++ [lower]
  end

  @doc """
  to_int(bignum) converts the bignum to an integer.

  ## Examples
    iex> 0 |> Asm.BigNum.from_int |> Asm.BigNum.to_int
    0
    iex> 1 |> Asm.BigNum.from_int |> Asm.BigNum.to_int
    1
    iex> Asm.max_uint + 1 |> Asm.BigNum.from_int |> Asm.BigNum.to_int
    0x1_0000_0000_0000_0000
    iex> -1 |> Asm.BigNum.from_int |> Asm.BigNum.to_int
    -1
    iex> -Asm.max_uint - 1 |> Asm.BigNum.from_int |> Asm.BigNum.to_int
    -0x1_0000_0000_0000_0000
  """
  def to_int({is_negative, bignum_p}) do
    result = bignum_p |> Enum.reduce(0, & &1 + bsl(&2, 64))
    case is_negative do
      0 -> result
      1  -> -result
    end
  end
end
