defmodule App73Web.Webhooks.GithubController do
  @moduledoc """
  Handles incoming GitHub webhooks.
  """
  require Logger
  use App73Web, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
