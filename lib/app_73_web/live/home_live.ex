defmodule App73Web.HomeLive do
  @moduledoc """
  LiveView for the home page.
  """
  require Logger
  use App73Web, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div></div>
    """
  end
end
