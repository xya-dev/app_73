defmodule App73.Domain.Repository do
  @moduledoc """
  Provides a common interface for data persistence and retrieval within the domain layer.
  """

  @callback persist(term()) :: :ok | {:error, term()}

  @callback load(term()) :: {:ok, term()} | :ok | {:error, term()}
end
