defmodule App73.Domain.Profile.Actor do
  @moduledoc """
  Represents user profile.
  """

  require Logger

  alias App73.Database.ProfileRepository
  alias App73.Domain.Profile.Command

  use GenServer, restart: :transient

  # 15 minutes in milliseconds
  @timeout 15 * 60 * 1000

  @type t :: %__MODULE__{
          id: String.t(),
          email: String.t(),
          provider: String.t(),
          provider_id: String.t(),
          created_at: DateTime.t()
        }

  defstruct [
    :id,
    :email,
    :provider,
    :provider_id,
    :created_at
  ]

  def get(profile_id) when is_binary(profile_id) do
    case Horde.DynamicSupervisor.start_child(
           App73.Domain.Profile.Supervisor,
           {__MODULE__, profile_id}
         ) do
      {:ok, pid} ->
        Logger.debug("Started profile actor with ID: #{profile_id}")
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        Logger.debug("Profile actor with ID: #{profile_id} already started")
        {:ok, pid}

      {:error, reason} ->
        Logger.error(
          "Failed to start profile actor with ID: #{profile_id}, reason: #{inspect(reason)}"
        )

        {:error, reason}
    end
  end

  def generate_id(provider, provider_id) when is_binary(provider) and is_binary(provider_id) do
    "#{provider}-#{provider_id}"
  end

  def init(id) do
    GenServer.cast(self(), {:load, id})
    {:ok, %__MODULE__{}, @timeout}
  end

  def start_link(id) do
    GenServer.start_link(__MODULE__, id, name: via_tuple(id))
  end

  def create(pid, cmd) do
    GenServer.call(pid, {:create, cmd})
  end

  def state(pid) do
    GenServer.call(pid, :state)
  end

  def handle_call({:create, %Command.Create{} = cmd}, _from, state) do
    new_profile = %__MODULE__{
      id: state.id,
      email: cmd.email,
      provider: cmd.provider,
      provider_id: cmd.provider_id,
      created_at: DateTime.utc_now()
    }

    case ProfileRepository.persist_actor(new_profile) do
      {:ok, _} ->
        {:reply, {:ok, new_profile}, new_profile, @timeout}

      {:error, reason} ->
        {:reply, {:error, reason}, state, @timeout}
    end
  end

  def handle_call(:state, _from, state) do
    case state.created_at do
      nil -> {:reply, nil, state, @timeout}
      _ -> {:reply, state, state, @timeout}
    end
  end

  def handle_cast({:load, id}, _state) when is_binary(id) do
    case ProfileRepository.get_by_id(id) do
      nil ->
        {:noreply,
         %__MODULE__{
           id: id
         }, @timeout}

      profile ->
        {:noreply, profile, @timeout}
    end
  end

  def handle_info(:timeout, state) do
    Logger.debug("Profile actor with ID: #{state.id} timed out")
    {:stop, :normal, state}
  end

  defp via_tuple(profile_id) do
    {:via, Horde.Registry, {App73.Domain.Profile.Registry, profile_id}}
  end
end
