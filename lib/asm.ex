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
  get_name(func) gets the name of the function.
  """
  def get_name(func) do
  	elem(func, 0)
  	|> Atom.to_string
  end

  @doc """
  args(func) gets the arguments of the function.
  """
  def args(func) do
  	elem(func, 2)
  end

  @doc """
  arity(func) gets the arity of the function.
  """
  def arity(func) do
  	func |> args |> length
  end

  @doc """
  get_name_all(type, func) generates a variation of a name of the function :func_ii that has the type like "i".
  """
  def get_name_all(type, func) do
  	(get_name(func) <> "_" <> (1..arity(func) |> Enum.map(fn _ -> type end) |> Enum.join()))
  	|> String.to_atom
  end

  @doc """
  get_func_all(type, func) generates a variation of the function :func_ii that has the type like "i", the location of line and the arguments same to the original function.
  """
  def get_func_all(type, func) do
  	{get_name_all(type, func), elem(func, 1), elem(func, 2)}
  end

  @doc """
  when_and_int64(func) generates the function with a when clause that all of arguments of the function should be int64.
  """
  defp when_and_int64(func) do
  	{:when, [context: Elixir],
  		[
  			get_func_all("i", func),
  			{:and, [context: Elixir, import: Kernel],
  				args(func)
  				|> Enum.map(& {{:., [], [{:__aliases__, [alias: false], [:Asm]}, :is_int64]}, [], [&1]})
  			}
  		]
  	}
  end

  @doc """
  when_and_uint64(func) generates the function with a when clause that all of arguments of the function should be uint64.
  """
  defp when_and_uint64(func) do
  	{:when, [context: Elixir],
  		[
  			get_func_all("u", func),
  			{:and, [context: Elixir, import: Kernel],
  				args(func)
  				|> Enum.map(& {{:., [], [{:__aliases__, [alias: false], [:Asm]}, :is_uint64]}, [], [&1]})
  			}
  		]
  	}
  end

  @doc """
  when_and_float64(func) generates the function with a when clause that all of arguments of the function should be float.
  """
  defp when_and_float(func) do
  	{:when, [context: Elixir],
  		[
  			get_func_all("f", func),
  			{:and, [context: Elixir, import: Kernel],
  				args(func)
  				|> Enum.map(& {:is_float, [contezt: Elixir, import: Kernel], [&1]})
  			}
  		]
  	}
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
  		def unquote(when_and_int64(func)), unquote(do_clause)
  		def unquote(when_and_uint64(func)), unquote(do_clause)
  		def unquote(when_and_float(func)), unquote(do_clause)
  	end
  end
end
