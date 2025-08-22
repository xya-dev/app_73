defmodule App73.Schema.Profile do
  @moduledoc """
  User model for the database.
  """

  use Ecto.Schema

  @primary_key {:id, :string, autogenerate: false}

  schema "profiles" do
    field :email, :string
    field :provider, :string
    field :provider_id, :string

    timestamps()
  end
end
