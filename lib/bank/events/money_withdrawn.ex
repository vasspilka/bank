defmodule Bank.Core.Events.MoneyWithdrawn do
  @type t :: %__MODULE__{
          account_id: Bank.account_number(),
          amount: Bank.amount()
        }

  @derive Jason.Encoder
  defstruct [:account_id, :amount]
end
