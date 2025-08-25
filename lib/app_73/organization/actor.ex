defmodule App73.Organization.Actor do
  @moduledoc """
  An actor representing a user account in the system.
  """

  use App73.Common.Actor,
    registry: App73.Organization.Registry,
    supervisor: App73.Organization.Supervisor,
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
