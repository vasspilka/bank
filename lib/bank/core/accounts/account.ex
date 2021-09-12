defmodule Bank.Core.Accounts.Account do
  alias Bank.Core.Commands.{
    DepositMoney,
    WithdrawMoney,
    SendMoneyToAccount,
    ReceiveMoneyFromAccount,
    FailMoneyTransfer
  }

  alias Bank.Core.Events.{
    MoneyDeposited,
    MoneyWithdrawn,
    JournalEntryCreated,
    AccountOpened,
    MoneyReceivedFromAccount,
    MoneyReceivedFromAccountFailed,
    MoneySentToAccount,
    MoneyTransferFailed
  }

  alias Bank.Core.Accounts.Account

  @type t() :: %__MODULE__{id: binary(), balance: integer()}
  defstruct [:id, balance: 0]

  def execute(%Account{}, %DepositMoney{account_id: "000-000"}),
    do: {:error, :unable_to_create_account}

  def execute(%Account{id: nil}, %DepositMoney{} = cmd) do
    [
      %AccountOpened{
        account_id: cmd.account_id
      },
      %MoneyDeposited{
        account_id: cmd.account_id,
        amount: cmd.amount
      },
      %JournalEntryCreated{
        journal_entry_uuid: Ecto.UUID.generate(),
        debit: %{"#{cmd.account_id}" => cmd.amount},
        credit: %{"000-000" => cmd.amount}
      }
    ]
  end

  def execute(%Account{id: nil}, %ReceiveMoneyFromAccount{} = cmd) do
    %MoneyReceivedFromAccountFailed{
      transaction_id: cmd.transaction_id,
      from_account_id: cmd.from_account_id,
      to_account_id: cmd.to_account_id,
      amount: cmd.amount
    }
  end

  def execute(%Account{id: nil}, _cmd),
    do: {:error, :not_found}

  def execute(%Account{}, %DepositMoney{} = cmd) do
    [
      %MoneyDeposited{
        account_id: cmd.account_id,
        amount: cmd.amount
      },
      %JournalEntryCreated{
        journal_entry_uuid: Ecto.UUID.generate(),
        debit: %{"#{cmd.account_id}" => cmd.amount},
        credit: %{"000-000" => cmd.amount}
      }
    ]
  end

  def execute(%Account{}, %WithdrawMoney{} = cmd) do
    [
      %MoneyWithdrawn{
        account_id: cmd.account_id,
        amount: cmd.amount
      },
      %JournalEntryCreated{
        journal_entry_uuid: Ecto.UUID.generate(),
        debit: %{"000-000" => cmd.amount},
        credit: %{"#{cmd.account_id}" => cmd.amount}
      }
    ]
  end

  def execute(%Account{} = state, %ReceiveMoneyFromAccount{} = cmd) do
    [
      %MoneyReceivedFromAccount{
        transaction_id: cmd.transaction_id,
        from_account_id: cmd.from_account_id,
        to_account_id: state.id,
        amount: cmd.amount
      },
      %JournalEntryCreated{
        journal_entry_uuid: Ecto.UUID.generate(),
        credit: %{"#{cmd.transaction_id}" => cmd.amount},
        debit: %{"#{cmd.to_account_id}" => cmd.amount}
      }
    ]
  end

  def execute(%Account{} = state, %FailMoneyTransfer{} = cmd) do
    [
      %MoneyTransferFailed{
        transaction_id: cmd.transaction_id,
        from_account_id: state.id,
        to_account_id: cmd.to_account_id,
        amount: cmd.amount
      },
      %JournalEntryCreated{
        journal_entry_uuid: Ecto.UUID.generate(),
        credit: %{"#{cmd.transaction_id}" => cmd.amount},
        debit: %{"#{state.id}" => cmd.amount}
      }
    ]
  end

  def execute(%Account{balance: balance}, %SendMoneyToAccount{amount: amount})
      when balance < amount do
    {:error, :insufficient_balance}
  end

  def execute(%Account{} = state, %SendMoneyToAccount{} = cmd) do
    transaction_id = Ecto.UUID.generate()

    [
      %MoneySentToAccount{
        transaction_id: transaction_id,
        from_account_id: state.id,
        to_account_id: cmd.to_account_id,
        amount: cmd.amount
      },
      %JournalEntryCreated{
        journal_entry_uuid: Ecto.UUID.generate(),
        debit: %{"#{transaction_id}" => cmd.amount},
        credit: %{"#{state.id}" => cmd.amount}
      }
    ]
  end

  def apply(state, %MoneySentToAccount{} = evt) do
    %{state | balance: state.balance - evt.amount}
  end

  def apply(state, %MoneyTransferFailed{} = evt) do
    %{state | balance: state.balance + evt.amount}
  end

  def apply(state, %MoneyReceivedFromAccount{} = evt) do
    %{state | balance: state.balance + evt.amount}
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

  def apply(state, %MoneyReceivedFromAccountFailed{}), do: state
end
