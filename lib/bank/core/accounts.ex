defmodule Bank.Core.Accounts do
  @moduledoc """
  Core context to User Accounts.
  """

  alias Bank.Core.Commands.{DepositMoney, WithdrawMoney}
  alias Bank.Core.Accounts.Account

  @spec deposit_money(integer(), integer()) :: :ok | {:error, term()}
  def deposit_money(user_id, amount) do
    %DepositMoney{user_id: user_id, amount: amount}
    |> Bank.Core.Application.dispatch()
  end

  @spec withdraw_money(integer(), integer()) :: :ok | {:error, term()}
  def withdraw_money(user_id, amount) do
    %WithdrawMoney{user_id: user_id, amount: amount}
    |> Bank.Core.Application.dispatch()
  end
end
