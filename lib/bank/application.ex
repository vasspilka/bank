defmodule Bank.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Bank.Repo,
      BankWeb.Telemetry,
      {Phoenix.PubSub, name: Bank.PubSub},
      BankWeb.Endpoint,
      Bank.Core.Supervisor,
      Bank.Core.Accounting.AccountEntryProjector
    ]

    opts = [strategy: :one_for_one, name: Bank.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    BankWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
