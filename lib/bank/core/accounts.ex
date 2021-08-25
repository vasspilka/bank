defmodule Bank.Core.Accounts do
  @moduledoc "Core context of user Accounts."

  alias Bank.Core.Commands.{DepositMoney, WithdrawMoney}
  alias Commanded.Commands.ExecutionResult

  @spec deposit_money(integer(), integer()) ::
          {:ok, ExecutionResult.t()} | {:error, term()}
  def deposit_money(uid, amount) do
    %DepositMoney{account_id: create_account_id(uid), amount: amount}
    |> Bank.Core.Application.dispatch(returning: :execution_result)
  end

  @spec withdraw_money(integer(), integer()) ::
          {:ok, ExecutionResult.t()} | {:error, term()}
  def withdraw_money(uid, amount) do
    %WithdrawMoney{account_id: create_account_id(uid), amount: amount}
    |> Bank.Core.Application.dispatch(returning: :execution_result)
  end

  defp create_account_id(user_id), do: "101/#{user_id}"
end
