defmodule App73.Domain.Profile.Supervisor do
  use Supervisor

  @moduledoc """
  Supervisor for the App73 profile domain.
  """

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    children = [
      {Horde.Registry, keys: :unique, name: Project73.Domain.Profile.Registry},
      {Horde.DynamicSupervisor, name: Project73.Domain.Profile.Supervisor, strategy: :one_for_one}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
