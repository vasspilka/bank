defmodule Bank.Core.Commands.SendMoneyToAccount do
  @type t :: %__MODULE__{
          from_account_id: Bank.account_number(),
          to_account_id: Bank.account_number(),
          amount: Bank.amount()
        }

  defstruct [
    :from_account_id,
    :to_account_id,
    :amount
  ]
end
