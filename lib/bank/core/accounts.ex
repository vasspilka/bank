defmodule Bank.Core.Accounts do
  @moduledoc "Core context of user Accounts."

  alias Bank.Core.Commands.{DepositMoney, WithdrawMoney, SendMoneyToAccount}
  alias Commanded.Commands.ExecutionResult
  alias Bank.Core.Accounting.AccountEntry
  alias Bank.Repo
  import Ecto.Query

  @spec deposit_money(Bank.account_number(), Bank.amount()) ::
          {:ok, ExecutionResult.t()} | {:error, term()}
  def deposit_money(acc_id, amount) do
    %DepositMoney{account_id: acc_id, amount: amount}
    |> Bank.Core.Application.dispatch(returning: :execution_result)
  end

  @spec withdraw_money(Bank.account_number(), Bank.amount()) ::
          {:ok, ExecutionResult.t()} | {:error, term()}
  def withdraw_money(acc_id, amount) do
    %WithdrawMoney{account_id: acc_id, amount: amount}
    |> Bank.Core.Application.dispatch(returning: :execution_result)
  end

  @spec send_money(Bank.account_number(), Bank.account_number(), Bank.amount()) ::
          {:ok, ExecutionResult.t()} | {:error, term()}
  def send_money(from_acc_id, to_acc_id, amount) do
    %SendMoneyToAccount{from_account_id: from_acc_id, to_account_id: to_acc_id, amount: amount}
    |> Bank.Core.Application.dispatch(returning: :execution_result)
  end

  @spec view_balance(Bank.account_number()) :: Bank.amount()
  def view_balance(account) do
    Repo.one(
      from e in AccountEntry,
        where: e.account == ^account,
        select: sum(e.debit) - sum(e.credit)
    )
  end
end
