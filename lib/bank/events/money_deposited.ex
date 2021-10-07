defmodule Bank.Core.Events.MoneyDeposited do
  @type t :: %__MODULE__{
          account_id: Bank.account_number(),
          amount: Bank.amount()
        }

  @derive Jason.Encoder
  defstruct [:account_id, :amount]
end
