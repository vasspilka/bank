defmodule Bank.Core.Commands.FailMoneyTransfer do
  @type t :: %__MODULE__{
          transaction_id: binary(),
          from_account_id: Bank.account_number(),
          to_account_id: Bank.account_number(),
          amount: Bank.amount()
        }

  defstruct [
    :transaction_id,
    :from_account_id,
    :to_account_id,
    :amount
  ]
end
