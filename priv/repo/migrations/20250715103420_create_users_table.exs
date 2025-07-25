defmodule App73.Repo.Migrations.CreateUsersTable do
  @moduledoc """
  Creates the users table.
  """

  use Ecto.Migration

  def change do
    create table("users") do
      add :email, :string, null: false
      add :provider, :string, null: false
      add :provider_id, :string, null: false

      timestamps()
    end
  end
end
