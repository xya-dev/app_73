defmodule App73.Repo.Migrations.CreateUsersTable do
  @moduledoc """
  Creates the users table.
  """

  use Ecto.Migration

  def change do
    create table("users", primary_key: false) do
      add :id, :binary_id, primary_key: true, null: false
      add :email, :string, null: false
      add :provider, :string, null: false
      add :provider_id, :string, null: false

      timestamps()
    end
  end
end
