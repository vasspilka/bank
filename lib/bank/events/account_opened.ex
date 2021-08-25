defmodule Bank.Core.Events.AccountOpened do
  @type t :: %__MODULE__{account_id: integer()}

  defstruct [:account_id]
end
