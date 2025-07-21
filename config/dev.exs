import Config

config :app_73, App73.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "app_73",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :app_73, App73Web.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "BfSmU9yFTywskcdMfUP3JxXBZ7MiGmlpNY7h2QA5AzNhtqBSj8C6wy4qaw0RKgvJ",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:app_73, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:app_73, ~w(--watch)]}
  ]

config :app_73, App73Web.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/app_73_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

config :app_73, dev_routes: true

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  debug_heex_annotations: true,
  enable_expensive_runtime_checks: true

config :swoosh, :api_client, false

config :ngrok,
  executable: "ngrok"
