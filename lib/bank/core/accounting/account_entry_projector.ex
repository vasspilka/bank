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
        from_journal_entry(evt)
      )
    end
  )

  @spec from_journal_entry(%JournalEntryCreated{}) :: [AccountEntry.t()]
  defp from_journal_entry(journal_entry) do
    journal_entry
    |> Map.take([:debit, :credit])
    |> Enum.flat_map(fn {type, account_entries} ->
      Enum.map(account_entries, fn {account_id, amount} ->
        {account_id, type, amount}
      end)
    end)
    |> Enum.group_by(&elem(&1, 0), fn {_account_id, type, amount} ->
      {type, amount}
    end)
    |> convert_to_entries(journal_entry)
  end

  defp convert_to_entries(account_entries, journal_entry) do
    account_entries
    |> Enum.map(fn {account, entries} ->
      entries
      |> Enum.reduce(%{}, fn {type, amount}, acc ->
        Map.put(acc, type, amount)
      end)
      |> Map.merge(%{
        journal_entry_uuid: journal_entry.journal_entry_uuid,
        account: account
      })
    end)
  end
end
