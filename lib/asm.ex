defmodule Asm do
  use Constants

  @name :max_int
  @value 9_223_372_036_854_775_807

  @name :min_int
  @value -9_223_372_036_854_775_808

  @moduledoc """
  Asm aimed at implementing an inline assembler.

  Currently, it provides the following:

  * `is_int64` macro that can be used in `when` clauses to judge that a value is within INT64.
  * `max_int` is the constant value of maxium of INT64.
  * `min_int` is the constant value of minimum of INT64.
  """

  @doc """
  is_int64(value) returns true if the value is an integer, equals or is less than max_int and equals or is greater than min_int.
  """
  defmacro is_int64(value) do
    quote do
    	is_integer(unquote(value))
    	and unquote(value) <= unquote(Asm.max_int)
    	and unquote(value) >= unquote(Asm.min_int)
    end
  end

  def dummy(a), do: a
end
