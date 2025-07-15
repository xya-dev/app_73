import Config

config :app_73, App73.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "app_73_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

config :app_73, App73Web.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "/b+IjVo/rhKeS3ucNJEd62rI7MpeNjjTw0DxN9Q22QnplC2A3pGZ79gEwCYMhZtQ",
  server: false

config :app_73, App73.Mailer, adapter: Swoosh.Adapters.Test

config :swoosh, :api_client, false

config :logger, level: :warning

config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  enable_expensive_runtime_checks: true
