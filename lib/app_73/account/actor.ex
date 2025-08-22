defmodule App73.Account.Actor do
  @moduledoc """
  An actor representing a user account in the system.
  """

  use App73.Common.Actor,
    registry: App73.Account.Registry,
    supervisor: App73.Account.Supervisor,
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
