defmodule App73.Read.Schema.Profile do
  @moduledoc """
  User read model for the database.
  """

  use Ecto.Schema

  @primary_key {:id, :string, autogenerate: false}

  schema "profiles" do
    field :email, :string
    field :provider, :string
    field :provider_user_id, :string
    field :version, :integer
    timestamps()
  end
end
