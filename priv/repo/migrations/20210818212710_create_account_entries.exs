defmodule Bank.Repo.Migrations.CreateAccountEntries do
  use Ecto.Migration

  def change do
    create table(:accounting_account_entries_v1) do
      add :journal_entry_uuid, :uuid, null: false

      add :account, :string, null: false

      add :credit, :integer, default: 0, null: false
      add :debit, :integer, default: 0, null: false

      add :metadata, :map
    end
  end
end
