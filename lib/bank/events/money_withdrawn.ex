defmodule Bank.Core.Events.MoneyWithdrawn do
  @type t :: %__MODULE__{
          account_id: integer(),
          amount: integer()
        }

  defstruct [:account_id, :amount]
end
