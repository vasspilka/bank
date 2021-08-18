defmodule Bank.Core.Application do
  use Commanded.Application, otp_app: :bank

  router(Bank.Core.Router)
end
