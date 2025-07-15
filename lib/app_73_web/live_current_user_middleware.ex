defmodule App73Web.LiveCurrentUserMiddleware do
  @moduledoc """
  Injects the current user into live view sockets.
  """
  import Phoenix.LiveView
  import Phoenix.Component
  use App73Web, :verified_routes
  require Logger

  def on_mount(:public, _params, %{"user_id" => user_id}, socket) when is_binary(user_id) do
    {:cont, socket |> assign(:user_id, user_id)}
  end

  def on_mount(:public, _params, _session, socket) do
    {:cont, socket |> assign(:user_id, nil)}
  end

  def on_mount(:authorized, _params, %{"user_id" => user_id}, socket) when is_binary(user_id) do
    {:cont, socket |> assign(:user_id, user_id)}
  end

  def on_mount(:authorized, _params, _session, socket) do
    {:halt, socket |> redirect(to: ~p"/")}
  end
end
