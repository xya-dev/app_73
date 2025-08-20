defmodule App73.Domain.Supervisor do
  use Supervisor

  @moduledoc """
  Supervisor for the App73 domain.
  Manages the lifecycle of domain processes.
  """

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    children = [
      {Horde.Registry, keys: :unique, name: App73.Domain.Profile.Registry},
      {Horde.DynamicSupervisor, name: App73.Domain.Profile.Supervisor, strategy: :one_for_one}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
