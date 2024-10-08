defmodule RestarTestWeb.Router do
  use RestarTestWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {RestarTestWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RestarTestWeb do
    pipe_through :browser

    get "/", AddressesController, :index
    post "/addresses", AddressesController, :process_upload
    delete "/addresses", AddressesController, :clear
  end

  # Other scopes may use custom stacks.
  scope "/api", RestarTestWeb do
    pipe_through :api

    get "/", AddressesController, :index
    post "/addresses", AddressesController, :process_upload
    delete "/addresses", AddressesController, :clear
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:restar_test, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: RestarTestWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
