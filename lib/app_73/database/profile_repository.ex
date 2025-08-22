defmodule App73.Database.ProfileRepository do
  @moduledoc """
  Repository for managing user profiles in the database.
  """

  alias App73.Database.Schema.Profile
  alias App73.Profile.Actor
  alias App73.Repo
  alias App73.Utils.Option

  def get_by_id(id) when is_binary(id) do
    Repo.get(Profile, id)
    |> Option.map(
      &%Actor{
        id: &1.id,
        email: &1.email,
        provider: &1.provider,
        provider_id: &1.provider_id,
        created_at: &1.inserted_at
      }
    )
  end

  def persist_actor(%Actor{} = actor) do
    %Profile{
      id: actor.id,
      email: actor.email,
      provider: actor.provider,
      provider_id: actor.provider_id
    }
    |> Repo.insert()
  end
end
