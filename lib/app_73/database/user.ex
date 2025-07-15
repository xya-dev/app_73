defmodule App73.Database.User do
  @moduledoc """
  User model for the database.
  """

  use Ecto.Schema

  @primary_key {:id, Ecto.ULID, autogenerate: true}

  schema "users" do
    field :email, :string
    field :provider, :string
    field :provider_id, :string
  end
end
