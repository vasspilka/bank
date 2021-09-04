defmodule Bank.Core.Events.JournalEntryCreated do
  alias Bank.Core.Accounting

  @type t :: %__MODULE__{
          journal_entry_uuid: binary(),
          debit: Accounting.account_entries(),
          credit: Accounting.account_entries()
        }

  defstruct [:journal_entry_uuid, :debit, :credit]
end
