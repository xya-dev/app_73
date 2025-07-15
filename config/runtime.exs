import Config
import Dotenvy

env_dir_prefix = System.get_env("RELEASE_ROOT") || Path.expand(".")

source!([
  Path.absname(".#{config_env()}.env", env_dir_prefix),
  System.get_env()
])

if env!("PHX_SERVER", :boolean, false) do
  config :app_73, App73Web.Endpoint, server: true
end

auth_var_type = if config_env() == :test, do: :string, else: :string!

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: env!("GOOGLE_CLIENT_ID", auth_var_type, ""),
  client_secret: env!("GOOGLE_CLIENT_SECRET", auth_var_type, "")

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: env!("GITHUB_CLIENT_ID", auth_var_type, ""),
  client_secret: env!("GITHUB_CLIENT_SECRET", auth_var_type, "")

if config_env() == :prod do
  database_url =
    env!("DATABASE_URL", :string!)

  maybe_ipv6 = if env!("ECTO_IPV6", :boolean, false), do: [:inet6], else: []

  config :app_73, App73.Repo,
    url: database_url,
    pool_size: env!("POOL_SIZE", :integer!, 10),
    socket_options: maybe_ipv6

  secret_key_base =
    env!("SECRET_KEY_BASE", :string!)

  host = env!("PHX_HOST", :string!)
  port = env!("PORT", :integer!)

  config :app_73, App73Web.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base
end
