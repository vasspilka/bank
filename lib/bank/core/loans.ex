defmodule Bank.Core.Loans do
  @moduledoc """
  Core context to User Accounts.
  """

  alias Bank.Core.Commands.{CreateLoan, ApplyInterest}
  alias Commanded.Commands.ExecutionResult

  @spec create_loan([integer()], integer(), integer()) ::
          {:ok, ExecutionResult.t()} | {:error, term()}
  def create_loan(account_ids, amount, interest_rate) do
    %CreateLoan{
      account_ids: account_ids,
      amount: amount,
      interest_rate: interest_rate
    }
    |> Bank.Core.Application.dispatch(returning: :execution_result)
  end

  @spec apply_interest(binary()) ::
          {:ok, ExecutionResult.t()} | {:error, term()}
  def apply_interest(loan_uuid) do
    %ApplyInterest{loan_id: loan_uuid}
    |> Bank.Core.Application.dispatch(returning: :execution_result)
  end
end
