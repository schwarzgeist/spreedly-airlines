defmodule BackendWeb.Router do
  use BackendWeb, :router

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

  scope "/", BackendWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", BackendWeb do
    pipe_through :api

    post "/checkout/purchase", PurchaseController, :purchase 
    post "/checkout/deliver", DeliverController, :deliver
    post "/testkit/gateways", TestkitController, :gateways
    post "/testkit/transactions", TestkitController, :transactions
  end
end
