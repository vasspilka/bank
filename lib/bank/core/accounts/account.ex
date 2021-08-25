defmodule Bank.Core.Accounts.Account do
  alias Bank.Core.Commands.{DepositMoney, WithdrawMoney}
  alias Bank.Core.Events.{MoneyDeposited, MoneyWithdrawn, JournalEntryCreated, AccountOpened}
  alias Bank.Core.Accounts.Account

  @type t() :: %__MODULE__{id: binary(), balance: integer()}
  defstruct [:id, balance: 0]

  def execute(%Account{id: nil}, %DepositMoney{} = cmd) do
    [
      %AccountOpened{
        account_id: cmd.account_id
      }
    ] ++
      include_journal_entry(%MoneyDeposited{
        account_id: cmd.account_id,
        amount: cmd.amount
      })
  end

  def execute(%Account{}, %DepositMoney{} = cmd) do
    %MoneyDeposited{
      account_id: cmd.account_id,
      amount: cmd.amount
    }
    |> include_journal_entry()
  end

  def execute(%Account{id: nil}, _cmd), do: {:error, :bad_account}

  def execute(%Account{balance: balance}, %WithdrawMoney{amount: amount})
      when balance - amount < 0 do
    {:error, :insufficient_balance}
  end

  def execute(%Account{}, %WithdrawMoney{} = cmd) do
    %MoneyWithdrawn{
      account_id: cmd.account_id,
      amount: cmd.amount
    }
    |> include_journal_entry()
  end

  def apply(state, %AccountOpened{} = evt) do
    %{state | id: evt.account_id}
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
        debit: %{"#{event.account_id}" => event.amount},
        credit: %{"0" => event.amount}
      }
    ]
  end

  defp include_journal_entry(%MoneyWithdrawn{} = event) do
    [
      event,
      %JournalEntryCreated{
        journal_entry_uuid: Ecto.UUID.generate(),
        debit: %{"0" => event.amount},
        credit: %{"#{event.account_id}" => event.amount}
      }
    ]
  end
end
