defmodule Bank.Core.Accounts.MoneyTransferProcessManager do
  use Commanded.ProcessManagers.ProcessManager,
    name: "Bank.Core.Accounts.MoneyTransferProcessManager",
    start_from: :origin,
    application: Bank.Core.Application

  alias Bank.Core.Commands.{ReceiveMoneyFromAccount, FailMoneyTransfer}

  alias Bank.Core.Events.{
    MoneySendToAccount,
    MoneyReceivedFromAccount,
    MoneyReceivedFromAccountFailed,
    MoneyTransferFailed
  }

  defstruct [:transaction_id]

  def interested?(%MoneySendToAccount{transaction_id: id}), do: {:start, id}
  def interested?(%MoneyReceivedFromAccountFailed{transaction_id: id}), do: {:continue, id}
  def interested?(%MoneyReceivedFromAccount{transaction_id: id}), do: {:stop, id}
  def interested?(%MoneyTransferFailed{transaction_id: id}), do: {:stop, id}

  def handle(%__MODULE__{}, %MoneySendToAccount{} = evt),
    do: [
      %ReceiveMoneyFromAccount{
        transaction_id: evt.transaction_id,
        from_account_id: evt.from_account_id,
        to_account_id: evt.to_account_id,
        amount: evt.amount
      }
    ]

  def handle(%__MODULE__{}, %MoneyReceivedFromAccountFailed{} = evt),
    do: [
      %FailMoneyTransfer{
        transaction_id: evt.transaction_id,
        from_account_id: evt.from_account_id,
        to_account_id: evt.to_account_id,
        amount: evt.amount
      }
    ]

  def apply(_state, %MoneySendToAccount{} = evt) do
    %__MODULE__{transaction_id: evt.transaction_id}
  end
end
