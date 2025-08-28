defmodule App73Web.AuthController do
  @moduledoc """
  Handles authentication callbacks and session management.
  """

  alias App73.Profile
  alias App73.Common.{Result, Option}
  alias App73.Read
  require Logger
  use App73Web, :controller
  plug Ueberauth

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    success(conn, auth)
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "Logged out.")
    |> redirect(to: ~p"/")
  end

  defp success(conn, %Ueberauth.Auth{
         uid: provider_user_id,
         provider: provider,
         info: %Ueberauth.Auth.Info{email: email}
       })
       when is_binary(provider_user_id) and is_atom(provider) and is_binary(email) do
    provider = Atom.to_string(provider)

    create_new_profile = fn ->
      Profile.Actor.new()
      |> Result.tap(fn {pid, _id} ->
        Profile.Actor.create(pid, %Profile.Command.Create{
          email: email,
          provider: provider,
          provider_user_id: provider_user_id
        })
      end)
    end

    Read.ProfileRepository.get_by_provider_user_id(provider, provider_user_id)
    |> Result.flat_map(fn profile ->
      profile
      |> Option.map(fn p -> Profile.Actor.get(p.id) end)
      |> Option.or_else(create_new_profile)
    end)
    |> Result.map(fn {_pid, id} ->
      conn
      |> put_flash(:info, "Successfully authenticated.")
      |> put_session(:user_id, id)
      |> configure_session(renew: true)
      |> redirect(to: ~p"/")
    end)
    |> Result.ok_or_else(fn reason ->
      conn
      |> put_flash(:error, "Authentication error: #{inspect(reason)}")
      |> redirect(to: ~p"/")
    end)
  end
end
