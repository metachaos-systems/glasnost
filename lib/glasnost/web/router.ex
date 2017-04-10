defmodule Glasnost.Web.Router do
  use Glasnost.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Glasnost.Plugs.PutConfig
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Glasnost.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/tags/:tag", PageController, :tags
    get "/posts/:permlink", PageController, :show
    get "/authors/:author", PageController, :authors
    get "/authors/:author/:permlink", PageController, :show
    get "/admin", AdminController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Glasnost.Web do
  #   pipe_through :api
  # end
end
