import Config

config :app_73,
  ecto_repos: [App73.Repo],
  generators: [timestamp_type: :utc_datetime]

config :app_73, MyApp.Repo,
  migration_primary_key: [name: :id, type: :binary_id],
  migration_foreign_key: [type: :binary_id]

config :app_73, App73Web.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: App73Web.ErrorHTML, json: App73Web.ErrorJSON],
    layout: false
  ],
  pubsub_server: App73.PubSub,
  live_view: [signing_salt: "FBpZXZLt"]

config :app_73, App73.Mailer, adapter: Swoosh.Adapters.Local

config :esbuild,
  version: "0.17.11",
  app_73: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.4.3",
  app_73: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :libcluster,
  topologies: [
    gossip: [
      strategy: Cluster.Strategy.Gossip,
      config: [
        secret: "devsecret"
      ]
    ]
  ]

config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, []},
    github: {Ueberauth.Strategy.Github, []}
  ]

import_config "#{config_env()}.exs"
