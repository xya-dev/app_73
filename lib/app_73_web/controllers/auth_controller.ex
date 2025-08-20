defmodule App73Web.AuthController do
  @moduledoc """
  Handles authentication callbacks and session management.
  """

  alias App73.Domain.Profile
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
         uid: provider_id,
         provider: provider,
         info: %Ueberauth.Auth.Info{email: email}
       })
       when is_binary(provider_id) and is_atom(provider) and is_binary(email) do
    provider = Atom.to_string(provider)
    user_id = Profile.Actor.generate_id(provider, provider_id)

    with {:ok, pid} <- Profile.Actor.get(user_id) do
      profile = Profile.Actor.state(pid)

      case profile do
        nil ->
          cmd = %App73.Domain.Profile.Command.Create{
            email: email,
            provider: provider,
            provider_id: provider_id
          }

          App73.Domain.Profile.Actor.create(pid, cmd)
          Logger.info("Created new profile for user #{user_id}")

        _ ->
          Logger.info("User #{user_id} already exists")
      end
    end

    conn
    |> put_flash(:info, "Successfully authenticated.")
    |> put_session(:user_id, user_id)
    |> configure_session(renew: true)
    |> redirect(to: ~p"/")
  end
end
