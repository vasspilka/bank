defmodule Bank.Core.Accounting.AccountEntry do
  @moduledoc """
  This module defines the AccountEntry schema.
  Used to model single account entries.
  """

  use Ecto.Schema

  @type t() :: %__MODULE__{}

  schema "accounting_account_entries_v1" do
    field :journal_entry_uuid, :binary_id
    field :account, :string

    field :credit, :integer, default: 0
    field :debit, :integer, default: 0

    field :metadata, :map
  end

  @spec from_journal_entry(map()) :: list(map())
  def from_journal_entry(journal_entry) do
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
        account: account,
        metadata: journal_entry.metadata
      })
    end)
  end
end
