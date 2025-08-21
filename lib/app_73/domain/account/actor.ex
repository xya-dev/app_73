defmodule App73.Domain.Account.Actor do
  @moduledoc """
  An actor representing a user account in the system.
  """

  use App73.Utils.Actor,
    registry: App73.Domain.Account.Registry,
    supervisor: App73.Domain.Account.Supervisor,
    # 15 minutes in milliseconds
    timeout: 15 * 60 * 1000

  defstruct [
    :id,
    :name,
    :owner_id,
    :created_at
  ]

  def init(id) do
    GenServer.cast(self(), {:load, id})
    {:ok, %__MODULE__{}}
  end
end
