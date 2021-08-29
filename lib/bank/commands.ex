defmodule Bank.Core.Commands do
  defmodule DepositMoney do
    @type t :: %__MODULE__{
            account_id: integer(),
            amount: integer()
          }

    defstruct [:account_id, :amount]
  end

  defmodule WithdrawMoney do
    @type t :: %__MODULE__{
            account_id: integer(),
            amount: integer()
          }

    defstruct [:account_id, :amount]
  end

  defmodule CreateLoan do
    @type t :: %__MODULE__{
            loan_id: binary(),
            account_id: binary(),
            amount: integer(),
            loan_fee: integer()
          }

    defstruct [:loan_id, :account_id, :amount, :loan_fee]
  end
end
