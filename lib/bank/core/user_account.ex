defmodule Bank.Core.UserAccounts.UserAccount do
  alias Bank.Core.Commands.{DepositMoney, WithdrawMoney}
  alias Bank.Core.Events.{MoneyDeposited, MoneyWithdrawn}
  alias Bank.Core.UserAccounts.UserAccount

  @type t() :: %__MODULE__{balance: integer()}
  defstruct balance: 0

  def execute(%UserAccount{}, %DepositMoney{} = cmd) do
    %MoneyDeposited{
      user_id: cmd.user_id,
      amount: cmd.amount
    }
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
  end

  def apply(state, %MoneyDeposited{} = evt) do
    %{state | balance: state.balance + evt.amount}
  end

  def apply(state, %MoneyWithdrawn{} = evt) do
    %{state | balance: state.balance - evt.amount}
  end
end
