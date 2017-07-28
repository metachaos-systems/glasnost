defmodule Glasnost.Web.Router do
  use Glasnost.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  forward "/", Absinthe.Plug,
    schema: Glasnost.Schema

  scope "/api", Glasnost.Web do
    pipe_through :api

    get "/golos/comments/search", CommentController, :search
    get "/golos/comments/stats", CommentController, :stats
    get "/golos/comments/:author/:permlink", CommentController, :show
    # resources "/steem/comments", CommentController
    # resources "/golos/comments", CommentController
  end

  scope "/", Glasnost.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/streaming", PageController, :streaming_demo
    get "/admin", AdminController, :index
    get "/admin/onboarding", AdminController, :onboarding
    post "/admin/mark_password_as_saved", AdminController, :mark_password_as_saved
    post "/admin/command_and_control", AdminController, :command_and_control
  end

  # Other scopes may use custom stacks.
  # scope "/api", Glasnost.Web do
  #   pipe_through :api
  # end
end
