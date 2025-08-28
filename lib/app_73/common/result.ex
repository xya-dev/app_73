defmodule App73.Common.Result do
  @moduledoc """
  A utility module for handling results in a functional way.
  """

  def ok(value), do: {:ok, value}
  def error(reason), do: {:error, reason}

  def call(fun) when is_function(fun, 0) do
    try do
      {:ok, fun.()}
    rescue
      e -> {:error, e}
    end
  end

  def flat_map({:ok, value}, fun) when is_function(fun, 1) do
    fun.(value)
  end

  def flat_map({:error, reason}, _fun), do: {:error, reason}

  def map({:ok, value}, fun) when is_function(fun, 1) do
    {:ok, fun.(value)}
  end

  def map({:error, reason}, _fun), do: {:error, reason}

  def map_error({:ok, value}, _fun), do: {:ok, value}

  def map_error({:error, reason}, fun) when is_function(fun, 1) do
    {:error, fun.(reason)}
  end

  def ok_or_else({:ok, value}, _fun), do: value

  def ok_or_else({:error, reason}, fun) when is_function(fun, 1) do
    fun.(reason)
  end

  def tap({:ok, value}, fun) when is_function(fun, 1) do
    case fun.(value) do
      {:error, reason} -> {:error, reason}
      _ -> {:ok, value}
    end
  end

  def tap({:error, reason}, _fun), do: {:error, reason}
end
