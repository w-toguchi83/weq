defmodule WeqWeb.Router do
  use WeqWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", WeqWeb do
    pipe_through :api

    get "/ping",  PingController,  :index

    post "/fetch", FetchController, :index
    post "/count", CountController, :index
    post "/desc",  DescController,  :index
  end
end
