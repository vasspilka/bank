defmodule Bank.Core.Supervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(_args) do
    children = [
      Bank.Core.Application,
      Bank.Core.Accounting.AccountEntryProjector,
      Bank.Core.Accounts.MoneyTransferProcessManager
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
