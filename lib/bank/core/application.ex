defmodule Bank.Core.Application do
  use Commanded.Application, otp_app: :bank, stream_prefix: "myapp"

  router(Bank.Core.Router)
end
