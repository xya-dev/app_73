defmodule App73.Utils.Option do
  @moduledoc """
  Utility functions for working with options.
  """

  def map(nil, fun) when is_function(fun, 1) do
    nil
  end

  def map(value, fun) when is_function(fun, 1) do
    fun.(value)
  end
end
