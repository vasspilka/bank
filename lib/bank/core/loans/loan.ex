defmodule Bank.Core.Loans.Loan do
  @type t :: %__MODULE__{
          id: binary(),
          # account_ids: [integer()],
          # starting_amount: integer(),
          # remaining_total: integer(),
          # interest: integer()
        }

  defstruct [:id]
end
