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
end
