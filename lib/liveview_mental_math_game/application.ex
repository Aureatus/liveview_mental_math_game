defmodule LiveviewMentalMathGame.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LiveviewMentalMathGameWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:liveview_mental_math_game, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LiveviewMentalMathGame.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: LiveviewMentalMathGame.Finch},
      # Start a worker by calling: LiveviewMentalMathGame.Worker.start_link(arg)
      # {LiveviewMentalMathGame.Worker, arg},
      # Start to serve requests, typically the last entry
      LiveviewMentalMathGameWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveviewMentalMathGame.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LiveviewMentalMathGameWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
