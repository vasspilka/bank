defmodule Bank.Core.Loans.Loan do
  alias Bank.Core.Loans.Loan

  alias Bank.Core.Commands.{CreateLoan}

  alias Bank.Core.Events.{
    LoanCreated,
    JournalEntryCreated
  }

  @type t :: %__MODULE__{
          id: binary(),
          account_id: binary(),
          loan_amount: integer()
        }

  defstruct [:id, :account_id, :loan_amount]

  def execute(%Loan{id: nil}, %CreateLoan{} = cmd) do
    [_, user_id] = String.split(cmd.account_id)

    [
      %LoanCreated{
        loan_id: cmd.loan_id,
        account_id: cmd.account_id,
        amount: cmd.amount,
        loan_fee: cmd.loan_fee
      },
      %JournalEntryCreated{
        journal_entry_uuid: Ecto.UUID.generate(),
        debit: %{"#{cmd.account_id}" => cmd.amount, "400/#{user_id}" => cmd.loan_fee},
        credit: %{}
      }
    ]
  end

  def apply(%Loan{id: nil}, %LoanCreated{} = evt) do
    %Loan{
      id: evt.loan_id,
      account_id: evt.account_id,
      loan_amount: evt.amount
    }
  end
end
