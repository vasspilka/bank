defmodule Bank.Core.Router do
  use Commanded.Commands.Router

  alias Bank.Core.Commands

  dispatch(
    [
      Commands.DepositMoney,
      Commands.WithdrawMoney
    ],
    to: Bank.Core.Accounts.Account,
    identity: :account_id
  )

  dispatch(
    [Commands.SendMoneyToAccount],
    to: Bank.Core.Accounts.Account,
    identity: :from_account_id
  )

  dispatch(
    [Commands.ReceiveMoneyFromAccount],
    to: Bank.Core.Accounts.Account,
    identity: :to_account_id
  )
end
