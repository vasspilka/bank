defmodule Bank.Core.Events.LoanCreated do
  @type t :: %__MODULE__{
          loan_id: binary(),
          account_id: binary(),
          amount: integer(),
          loan_fee: integer()
        }

  defstruct [:loan_id, :account_id, :amount, :loan_fee]
end
