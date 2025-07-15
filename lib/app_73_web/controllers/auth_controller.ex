defmodule App73Web.AuthController do
  @moduledoc """
  Handles authentication callbacks and session management.
  """

  require Logger
  use App73Web, :controller
  plug Ueberauth

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    id = auth.uid
    email = auth.info.email
    provider = Atom.to_string(auth.provider)

    success(conn, "#{provider}-#{id}")
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "Logged out.")
    |> redirect(to: ~p"/")
  end

  defp success(conn, user_id) do
    conn
    |> put_flash(:info, "Successfully authenticated.")
    |> put_session(:user_id, user_id)
    |> configure_session(renew: true)
    |> redirect(to: ~p"/")
  end
end
