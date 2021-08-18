defmodule Bank.Events do
  defmodule MoneyDeposited do
    @type t :: %__MODULE__{
      user_id: integer(),
      amount: integer()
    }

    defstruct [:user_id, :amount]
  end

  defmodule MoneyWithdrawn do
    @type t :: %__MODULE__{
      user_id: integer(),
      amount: integer()
    }

    defstruct [:user_id, :amount]
  end
end
