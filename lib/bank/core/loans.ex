defmodule Bank.Core.Loans do
  @moduledoc "Core context to User Accounts."

  alias Bank.Core.Commands.{CreateLoan}
  alias Commanded.Commands.ExecutionResult

  @spec create_loan([integer()], integer(), integer()) ::
          {:ok, ExecutionResult.t()} | {:error, term()}
  def create_loan(account_id, amount, loan_fee) do
    %CreateLoan{
      loan_id: Ecto.UUID.generate(),
      account_id: account_id,
      amount: amount,
      loan_fee: loan_fee
    }
    |> Bank.Core.Application.dispatch(returning: :execution_result)
  end
end
