defmodule AppWeb.Router do
  use AppWeb, :router

  import AppWeb.AdmAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_adm
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AppWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", AppWeb do
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
      live_dashboard "/dashboard", metrics: AppWeb.Telemetry
    end
  end

  ## Authentication routes

  scope "/", AppWeb do
    pipe_through [:browser, :redirect_if_adm_is_authenticated]

    get "/admins/register", AdmRegistrationController, :new
    post "/admins/register", AdmRegistrationController, :create
    get "/admins/log_in", AdmSessionController, :new
    post "/admins/log_in", AdmSessionController, :create
    get "/admins/reset_password", AdmResetPasswordController, :new
    post "/admins/reset_password", AdmResetPasswordController, :create
    get "/admins/reset_password/:token", AdmResetPasswordController, :edit
    put "/admins/reset_password/:token", AdmResetPasswordController, :update
  end

  scope "/", AppWeb do
    pipe_through [:browser, :require_authenticated_adm]

    get "/admins/settings", AdmSettingsController, :edit
    put "/admins/settings/update_password", AdmSettingsController, :update_password
    put "/admins/settings/update_email", AdmSettingsController, :update_email
    get "/admins/settings/confirm_email/:token", AdmSettingsController, :confirm_email
  end

  scope "/", AppWeb do
    pipe_through [:browser]

    delete "/admins/log_out", AdmSessionController, :delete
    get "/admins/confirm", AdmConfirmationController, :new
    post "/admins/confirm", AdmConfirmationController, :create
    get "/admins/confirm/:token", AdmConfirmationController, :confirm
  end
end
