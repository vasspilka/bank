defmodule Bank.Core.Accounting do
  @moduledoc "Accounting context."

  alias Bank.Core.Accounting.AccountEntry
  alias Bank.Core.Events.JournalEntryCreated
  alias Bank.Repo
  import Ecto.Query

  @spec create_raw_entry(Bank.account_entries(), Bank.account_entries()) ::
          :ok | {:error, term()}
  def create_raw_entry(debit, credit) do
    Bank.Core.EventStore.append_to_stream("raw_entries", :any_version, [
      %EventStore.EventData{
        event_id: Ecto.UUID.generate(),
        event_type: "#{JournalEntryCreated}",
        causation_id: Ecto.UUID.generate(),
        correlation_id: Ecto.UUID.generate(),
        data: %JournalEntryCreated{
          journal_entry_uuid: Ecto.UUID.generate(),
          debit: debit,
          credit: credit
        }
      }
    ])
  end

  @spec current_balance(Bank.account_number()) :: integer()
  def current_balance(account) do
    Repo.one(
      from e in AccountEntry,
        where: e.account == ^account,
        select: sum(e.debit) - sum(e.credit)
    )
  end

  @spec validate_event(%JournalEntryCreated{}) :: :ok | {:error, term()}
  def validate_event(je) do
    total_debit = je.debit |> Map.values() |> Enum.sum()
    total_credit = je.credit |> Map.values() |> Enum.sum()

    if total_debit == total_credit do
      :ok
    else
      {:error, :bad_entry}
    end
  end
end
