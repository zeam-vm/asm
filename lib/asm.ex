defmodule Asm do
  use Constants

  @name :max_int
  @value 9_223_372_036_854_775_807

  @name :min_int
  @value -9_223_372_036_854_775_808

  @moduledoc """
  Documentation for Asm.
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
