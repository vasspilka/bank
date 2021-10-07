defmodule Bank.Core.Application do
  use Commanded.Application, otp_app: :bank, stream_prefix: "aa1"

  router(Bank.Core.Router)
end
