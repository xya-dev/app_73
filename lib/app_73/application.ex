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
        {Cluster.Supervisor, [topologies, [name: App73.ClusterSupervisor]]},
        {Phoenix.PubSub, name: App73.PubSub},
        {Finch, name: App73.Finch},
        if(Mix.env() == :dev, do: {Ngrok, port: 4000, name: App73.Ngrok}),
        App73Web.Endpoint
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
