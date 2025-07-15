defmodule App73Web.Router do
  use App73Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {App73Web.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", App73Web do
    pipe_through :browser

    live_session :public, on_mount: {App73Web.LiveCurrentUserMiddleware, :public} do
      live "/", HomeLive
      live "/login", LoginLive
    end

    scope "/auth" do
      delete "/logout", AuthController, :delete

      get "/:provider", AuthController, :request
      get "/:provider/callback", AuthController, :callback
    end
  end

  scope "/api", App73Web do
    pipe_through :api
  end

  if Application.compile_env(:app_73, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: App73Web.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
