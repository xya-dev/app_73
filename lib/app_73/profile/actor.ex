defmodule App73.Profile.Actor do
  @moduledoc """
  Represents user profile.
  """

  alias App73.Database.ProfileRepository
  alias App73.Profile.Command

  use App73.Utils.Actor,
    registry: App73.Profile.Registry,
    supervisor: App73.Profile.Supervisor,
    # 15 minutes in milliseconds
    timeout: 15 * 60 * 1000

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

  def generate_id(provider, provider_id) when is_binary(provider) and is_binary(provider_id) do
    "#{provider}-#{provider_id}"
  end

  def init(id) do
    GenServer.cast(self(), {:load, id})
    {:ok, %__MODULE__{}}
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
      {:ok, _} -> reply({:ok, new_profile}, new_profile)
      {:error, reason} -> reply({:error, reason}, state)
    end
  end

  def handle_call(:state, _from, state) do
    case state.created_at do
      nil -> nil
      _ -> state
    end
    |> reply(state)
  end

  def handle_cast({:load, id}, _state) when is_binary(id) do
    case ProfileRepository.get_by_id(id) do
      nil ->
        %__MODULE__{
          id: id
        }

      profile ->
        profile
    end
    |> noreply()
  end

  def handle_info(:timeout, state) do
    Logger.debug("Profile actor with ID: #{state.id} timed out")
    {:stop, :normal, state}
  end
end
