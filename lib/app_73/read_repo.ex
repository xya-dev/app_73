defmodule App73.ReadRepo do
  @moduledoc """
  Read-only repository for read operations.
  """

  use Ecto.Repo,
    otp_app: :app_73,
    adapter: Ecto.Adapters.Postgres,
    read_only: true
end
