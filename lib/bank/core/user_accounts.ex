defmodule Bank.Core.UserAccounts do
  @moduledoc """
  Core context to User Accounts.
  """

  alias Bank.Core.Commands.{DepositMoney, WithdrawMoney}
  alias Bank.Core.UserAccounts.UserAccount

  @spec deposit_money(integer(), integer()) :: %UserAccount{}
  def deposit_money(user_id, amount) do
    %DepositMoney{user_id: user_id, amount: amount}
    |> Bank.Core.Application.dispatch(returning: :aggregate_state)
  end

  @spec withdraw_money(integer(), integer()) :: %UserAccount{}
  def withdraw_money(user_id, amount) do
    %WithdrawMoney{user_id: user_id, amount: amount}
    |> Bank.Core.Application.dispatch(returning: :aggregate_state)
  end
end
