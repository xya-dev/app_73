defmodule App73.Read.ProfileRepository do
  @moduledoc """
  Read-only repository for managing user profiles in the database.
  """

  alias App73.ReadRepo
  alias App73.Common.Result
  alias App73.Read.Schema.Profile

  def get_by_provider_user_id(provider, provider_user_id)
      when is_binary(provider) and is_binary(provider_user_id) do
    Result.call(fn ->
      ReadRepo.get_by(Profile, provider: provider, provider_user_id: provider_user_id)
    end)
  end
end
