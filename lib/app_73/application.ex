defmodule App73.Application do
  @moduledoc """
  Main application module for the `App73` application.
  """
  use Application

  @impl true
  def start(_type, _args) do
    topologies = Application.get_env(:libcluster, :topologies) || []

    children =
      [
        App73Web.Telemetry,
        App73.Repo,
        App73.ReadRepo,
        {Cluster.Supervisor, [topologies, [name: App73.ClusterSupervisor]]},
        {Phoenix.PubSub, name: App73.PubSub},
        {Finch, name: App73.Finch},
        App73Web.Endpoint,
        {Horde.Registry, keys: :unique, name: App73.Profile.Registry},
        {Horde.DynamicSupervisor, name: App73.Profile.Supervisor, strategy: :one_for_one},
        {Horde.Registry, keys: :unique, name: App73.Account.Registry},
        {Horde.DynamicSupervisor, name: App73.Account.Supervisor, strategy: :one_for_one}
      ]
      |> Enum.reject(&is_nil/1)

    opts = [strategy: :one_for_one, name: App73.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    App73Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
