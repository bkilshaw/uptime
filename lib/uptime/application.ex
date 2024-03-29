defmodule Uptime.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      UptimeWeb.Telemetry,
      Uptime.Repo,
      {DNSCluster, query: Application.get_env(:uptime, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Uptime.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Uptime.Finch},
      # Start a worker by calling: Uptime.Worker.start_link(arg)
      # {Uptime.Worker, arg},
      # Start to serve requests, typically the last entry
      UptimeWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Uptime.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    UptimeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
