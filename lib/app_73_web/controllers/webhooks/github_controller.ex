defmodule App73Web.Webhooks.GithubController do
  @moduledoc """
  Handles incoming GitHub webhooks.
  """
  require Logger
  use App73Web, :controller

  def index(conn, _params) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "")
  end
end
