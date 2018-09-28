defmodule Asm do
  use Constants

  @name :max_int
  @value 0x7fff_ffff_ffff_ffff

  @name :min_int
  @value -0x8000_0000_0000_0000


  @name :max_uint
  @value 0xffff_ffff_ffff_ffff

  @name :min_uint
  @value 0



  @moduledoc """
  Asm aimed at implementing an inline assembler.

  Currently, it provides the following:

  * `is_int64` macro that can be used in `when` clauses to judge that a value is within INT64.
  * `is_uint64` macro that can be used in `when` clauses to judge that a value is within UINT64.
  * `is_bignum` macro that can be used in `when` clauses to judge that a value needs BigNum representation, that is, it is an integer but not within INT64 nor UINT64.
  * `max_int` is the constant value of maxium of INT64.
  * `min_int` is the constant value of minimum of INT64.
  """

  @doc """
  is_int64(value) returns true if the value is a signed integer, equals or is less than max_int and equals or is greater than min_int.
  """
  defmacro is_int64(value) do
    quote do
    	is_integer(unquote(value))
    	and unquote(value) <= unquote(Asm.max_int)
    	and unquote(value) >= unquote(Asm.min_int)
    end
  end

  @doc """
  is_uint64(value) returns true if the value is an unsigned integer, equals or is less than max_uint and equals or is greater than min_uint.
  """
  defmacro is_uint64(value) do
    quote do
      is_integer(unquote(value))
      and unquote(value) <= unquote(Asm.max_uint)
      and unquote(value) >= unquote(Asm.min_uint)
    end
  end

  @doc """
  is_bignum(value) returns true if the value is an integer but larger than max_uint and smaller than min_int.
  """
  defmacro is_bignum(value) do
    quote do
      is_integer(unquote(value))
      and (unquote(value) > unquote(Asm.max_uint)
      or unquote(value) < unquote(Asm.min_int))
    end
  end

  @doc """
  make_clauses makes a clause or clauses into a list of it / them.
  """
  def make_clauses(clause) when is_tuple(clause), do: [clause]
  def make_clauses(clauses) when is_list(clauses), do: clauses

  @doc """
  unwrap_do eliminates the do header from do clauses and makes them into a list of clauses
  """
  def unwrap_do(do_clauses) do
  	do_clauses
  	|> Keyword.get(:do, nil)
  	|> make_clauses
  end

  @doc """
  wrap_do generates do clauses wrapping the orginal clauses with :do
  """
  def wrap_do(clauses) do
  	Keyword.put([], :do, clauses)
  end

  @doc """
  asm generates a fragment of assembly code.
  """
  defmacro asm clause do
 		operands = case elem(clause, 0) do
 			:add -> elem(clause, 2)
 			_ -> raise ArgumentError, "asm supports only add"
 		end
 		quote do
 			 unquote({:+, [context: Elixir, import: Kernel], operands})
 		end
  end

  @doc """
  def_nif defines a NIF that includes micro Elixir code.
  """
  defmacro def_nif func, do_clause do
  	quote do
  		def unquote(func), unquote(do_clause)
  	end
  end
end
