defmodule App73.Repo.Migrations.Initial do
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

    create table("accounts") do
      add :name, :string, null: false
      add :slug, :string, null: false
      add :owner_id, references("users", on_delete: :delete_all), null: false

      timestamps()
    end

    create table("github_integrations") do
      add :account_id, references("accounts", on_delete: :delete_all), null: false
      add :installation_id, :string, null: false

      timestamps()
    end
  end
end
