defmodule App73.Repo.Migrations.Initial do
  @moduledoc """
  Creates the users table.
  """

  use Ecto.Migration

  def change do
    create table("profiles", primary_key: false) do
      add :id, :string, primary_key: true, null: false
      add :email, :string, null: false
      add :provider, :string, null: false
      add :provider_id, :string, null: false
      add :version, :integer, null: false, default: 1

      timestamps()
    end

    create index("profiles", [:email], unique: true)
    create unique_index("profiles", [:provider, :provider_id], unique: true)

    create table("accounts") do
      add :name, :string, null: false
      add :slug, :string, null: false
      add(:owner_id, references("profiles", on_delete: :delete_all, type: :string), null: false)

      timestamps()
    end

    create table("github_integrations") do
      add :account_id, references("accounts", on_delete: :delete_all), null: false
      add :installation_id, :string, null: false

      timestamps()
    end
  end
end
