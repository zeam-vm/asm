defmodule Asm do
  @moduledoc """
  Documentation for Asm.
  """

  @doc """
  is_int64(value) returns true if the value is an integer, equals or is less than max_int and equals or is greater than min_int.
  """
  defmacro is_int64(value) do
    quote do: is_integer(unquote(value)) and unquote(value) <= unquote(9_223_372_036_854_775_807) and unquote(value) >= unquote(-9_223_372_036_854_775_808)
  end

  def dummy(a), do: a
end
