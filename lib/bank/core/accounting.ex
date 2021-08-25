defmodule Bank.Core.Accounting do
  @moduledoc "Accounting context."

  alias Bank.Core.Events.JournalEntryCreated
  alias Bank.Repo
  import Ecto.Query

  @type account_entries() :: %{binary() => integer()}

  @spec create_raw_entry(account_entries(), account_entries()) ::
          :ok | {:error, term()}
  def create_raw_entry(debit, credit) do
    journal_entry = %JournalEntryCreated{
      journal_entry_uuid: UUID.uuid4(),
      debit: debit,
      credit: credit
    }

    with :ok <- validate_event(journal_entry) do
      data = %EventStore.EventData{
        causation_id: Ecto.UUID.generate(),
        correlation_id: Ecto.UUID.generate(),
        data: journal_entry,
        event_id: Ecto.UUID.generate(),
        event_type: "#{JournalEntryCreated}",
        metadata: %{}
      }

      Bank.Core.EventStore.append_to_stream("raw_entries", :any_version, [data])
    end
  end

  @spec current_balance(binary()) :: integer()
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
