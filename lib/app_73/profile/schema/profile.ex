defmodule App73.Schema.Profile do
  @moduledoc """
  User model for the database.
  """

  use Ecto.Schema

  @primary_key {:id, :string, autogenerate: false}

  schema "profiles" do
    field :email, :string
    field :provider, :string
    field :provider_user_id, :string
    field :version, :integer, default: 1

    timestamps()
  end

  def changeset(:update, struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, [:version])
    |> Ecto.Changeset.validate_required([:version])
    |> Ecto.Changeset.optimistic_lock(:version)
  end
end
