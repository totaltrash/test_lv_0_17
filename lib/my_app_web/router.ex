defmodule MyAppWeb.Router do
  use MyAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MyAppWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_session_id
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  live_session :default, on_mount: MyAppWeb.InitAssigns do
    scope "/", MyAppWeb do
      pipe_through :browser

      live "/", HomeLive, :index
      live "/components", ComponentsLive, :index
      live "/components/alert_modal", ComponentsLive, :show_alert_modal
      live "/components/confirm_modal", ComponentsLive, :show_confirm_modal
      live "/components/form_modal", ComponentsLive, :show_form_modal
      live "/components/custom_modal", ComponentsLive, :show_custom_modal
      live "/components_tables", ComponentsTablesLive, :index
      live "/components_forms", ComponentsFormsLive, :index
      live "/resourceloader", ResourceLoaderLive, :index
      live "/temporaryassigns", TemporaryAssignsLive, :index
      live "/timestamps", TimestampsLive, :index
      live "/timestamps/show/:id", TimestampsLive, :show
      live "/timestamps/edit/:id", TimestampsLive, :edit
      live "/uploads", UploadsLive, :index
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", MyAppWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: MyAppWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  def put_session_id(conn, _opts) do
    case get_session(conn, :session_id) do
      nil ->
        create_and_put_session_id(conn)

      session_id ->
        case MyApp.Accounts.get(MyApp.Accounts.Session, session_id) do
          {:ok, %MyApp.Accounts.Session{}} -> conn
          _ -> create_and_put_session_id(conn)
        end
    end
  end

  defp create_and_put_session_id(conn) do
    session =
      MyApp.Accounts.Session
      |> Ash.Changeset.for_create(:create)
      |> MyApp.Accounts.create!()

    put_session(conn, :session_id, session.id)
  end
end
