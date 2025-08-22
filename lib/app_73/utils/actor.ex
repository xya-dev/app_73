defmodule App73.Utils.Actor do
  @moduledoc """
  A utility module for creating actors in a distributed system using Horde.
  """

  defmacro __using__(opts) do
    registry = Keyword.get(opts, :registry)
    supervisor = Keyword.get(opts, :supervisor)
    timeout = Keyword.get(opts, :timeout)

    quote do
      require Logger
      use GenServer, restart: :transient

      unquote(result_functions(timeout))
      unquote(start_link_function(registry))
      unquote(getter_function(supervisor))
    end
  end

  defp start_link_function(registry) when not is_nil(registry) do
    quote do
      def start_link(id) do
        GenServer.start_link(
          __MODULE__,
          id,
          name: {:via, Horde.Registry, {unquote(registry), id}}
        )
      end
    end
  end

  defp start_link_function(_) do
    quote do
    end
  end

  def getter_function(supervisor) when not is_nil(supervisor) do
    quote do
      def get(id) when is_binary(id) do
        case Horde.DynamicSupervisor.start_child(
               unquote(supervisor),
               {__MODULE__, id}
             ) do
          {:ok, pid} ->
            Logger.debug("Started #{__MODULE__} actor with ID: #{id}")
            {:ok, pid}

          {:error, {:already_started, pid}} ->
            Logger.debug("#{__MODULE__} actor with ID: #{id} already started")
            {:ok, pid}

          {:error, reason} ->
            Logger.error(
              "Failed to start #{__MODULE__} actor with ID: #{id}, reason: #{inspect(reason)}"
            )

            {:error, reason}
        end
      end
    end
  end

  def getter_function(_) do
    quote do
    end
  end

  defp result_functions(timeout) when is_integer(timeout) do
    quote do
      defp reply(answer, state) do
        {:reply, answer, state, unquote(timeout)}
      end

      defp noreply(state) do
        {:noreply, state, unquote(timeout)}
      end
    end
  end

  defp result_functions(_) do
    quote do
      defp reply(answer, state) do
        {:reply, answer, state}
      end

      defp noreply(state) do
        {:noreply, state}
      end
    end
  end
end
