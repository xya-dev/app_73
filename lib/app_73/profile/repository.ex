defmodule App73.Repository do
  @moduledoc """
  Repository for managing user profiles in the database.
  """

  alias App73.Schema.Profile
  alias App73.Profile.Actor
  alias App73.Repo
  alias App73.Common.Option
  alias App73.Common.Result

  def get_by_id(id) when is_binary(id) do
    Result.call(fn ->
      Repo.get(Profile, id)
      |> Option.map(
        &%Actor{
          id: &1.id,
          email: &1.email,
          provider: &1.provider,
          provider_user_id: &1.provider_user_id,
          created_at: &1.inserted_at
        }
      )
    end)
  end

  def persist_actor(%Actor{} = actor) do
    Result.call(fn ->
      %Profile{
        id: actor.id,
        email: actor.email,
        provider: actor.provider,
        provider_user_id: actor.provider_user_id
      }
      |> Repo.insert()
    end)
  end
end
