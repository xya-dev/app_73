defmodule App73Web.LoginLive do
  require Logger
  use App73Web, :live_view

  def mount(_params, _session, socket) do
    case socket.assigns.user_id do
      nil ->
        {:ok, socket}

      _ ->
        Logger.info(%{
          message: "User is already logged in",
          user_id: socket.assigns.current_user.id
        })

        {:ok, socket |> push_navigate(to: ~p"/", replace: true)}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="space-y-4">
      <.link href={~p"/auth/github"}>
        Login with Github
      </.link>
      <.link href={~p"/auth/google"}>
        Login with Google
      </.link>
    </div>
    """
  end
end
