defmodule Bank.Core.Accounting do
  @moduledoc """
  Accounting context.
  """

  import Ecto.Query

  alias Bank.Core.Accounting.AccountEntry
  alias Bank.Repo

  @spec create_account_entries(map()) :: {integer(), nil | [term()]}
  def create_account_entries(journal_entry) do
    Repo.insert_all(AccountEntry, AccountEntry.from_journal_entry(journal_entry))
  end

  @spec current_balance(binary()) :: integer()
  def current_balance(account) do
    Repo.one(
      from e in AccountEntry,
        where: e.account == ^account,
        select: sum(e.debit) - sum(e.credit)
    )
  end
end
