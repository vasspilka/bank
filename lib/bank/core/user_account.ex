defmodule Bank.Core.UserAccounts.UserAccount do
  alias Bank.Core.Commands.{DepositMoney, WithdrawMoney}
  alias Bank.Core.Events.{MoneyDeposited, MoneyWithdrawn, JournalEntryCreated}
  alias Bank.Core.UserAccounts.UserAccount

  @type t() :: %__MODULE__{balance: integer()}
  defstruct balance: 0

  def execute(%UserAccount{}, %DepositMoney{} = cmd) do
    %MoneyDeposited{
      user_id: cmd.user_id,
      amount: cmd.amount
    }
    |> include_journal_entry()
  end

  def execute(%UserAccount{balance: balance}, %WithdrawMoney{amount: amount})
      when balance - amount < 0 do
    {:error, :insufficient_balance}
  end

  def execute(%UserAccount{}, %WithdrawMoney{} = cmd) do
    %MoneyWithdrawn{
      user_id: cmd.user_id,
      amount: cmd.amount
    }
    |> include_journal_entry()
  end

  def apply(state, %MoneyDeposited{} = evt) do
    %{state | balance: state.balance + evt.amount}
  end

  def apply(state, %MoneyWithdrawn{} = evt) do
    %{state | balance: state.balance - evt.amount}
  end

  def apply(state, %JournalEntryCreated{}), do: state

  defp include_journal_entry(%MoneyDeposited{} = event) do
    [
      event,
      %JournalEntryCreated{
        journal_entry_uuid: Ecto.UUID.generate(),
        debit: %{"#{event.user_id}" => event.amount},
        credit: %{"0" => event.amount},
        metadata: %{event: event.__struct__}
      }
    ]
  end

  defp include_journal_entry(%MoneyWithdrawn{} = event) do
    [
      event,
      %JournalEntryCreated{
        journal_entry_uuid: Ecto.UUID.generate(),
        debit: %{"0" => event.amount},
        credit: %{"#{event.user_id}" => event.amount},
        metadata: %{event: event.__struct__}
      }
    ]
  end
end
