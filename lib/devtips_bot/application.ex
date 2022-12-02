defmodule DevtipsBot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      DevtipsBot.Repo,
      # Start the Telemetry supervisor
      DevtipsBotWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: DevtipsBot.PubSub},
      # Start the Endpoint (http/https)
      DevtipsBotWeb.Endpoint,
      # Start a worker by calling: DevtipsBot.Worker.start_link(arg)
      # {DevtipsBot.Worker, arg}
      {Cachex, name: :app_cache}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DevtipsBot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DevtipsBotWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
