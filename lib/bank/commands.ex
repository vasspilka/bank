defmodule Bank.Core.Commands do
  defmodule DepositMoney do
    @type t :: %__MODULE__{
            user_id: integer(),
            amount: integer()
          }

    defstruct [:user_id, :amount]
  end

  defmodule WithdrawMoney do
    @type t :: %__MODULE__{
            user_id: integer(),
            amount: integer()
          }

    defstruct [:user_id, :amount]
  end

  defmodule CreateLoan do
    @type t :: %__MODULE__{
            account_ids: [integer()],
            amount: integer(),
            interest_rate: integer()
          }

    defstruct [:account_ids, :amount, :interest_rate]
  end

  defmodule ApplyInterest do
    @type t :: %__MODULE__{loan_id: binary()}

    defstruct [:loan_id]
  end
end
