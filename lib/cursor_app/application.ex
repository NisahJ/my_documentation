defmodule CursorApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CursorAppWeb.Telemetry,
      CursorApp.Repo,
      {DNSCluster, query: Application.get_env(:cursor_app, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: CursorApp.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: CursorApp.Finch},
      # Start a worker by calling: CursorApp.Worker.start_link(arg)
      # {CursorApp.Worker, arg},
      # Start to serve requests, typically the last entry
      CursorAppWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CursorApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CursorAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
