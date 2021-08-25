defmodule Bank.Core.Accounting.AccountEntryProjector do
  use Commanded.Projections.Ecto,
    name: "Accounting.AccountEntriesProjector",
    application: Bank.Core.Application,
    consistency: :strong

  alias Bank.Core.Accounting.AccountEntry
  alias Bank.Core.Events.JournalEntryCreated

  project(
    %JournalEntryCreated{} = evt,
    _metadata,
    fn multi ->
      Ecto.Multi.insert_all(
        multi,
        :insert_account_entries,
        AccountEntry,
        AccountEntry.from_journal_entry(evt)
      )
    end
  )
end
