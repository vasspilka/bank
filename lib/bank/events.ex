defmodule Bank.Core.Events do

  defmodule JournalEntryCreated do
    @type account_entries() :: %{binary() => integer()}
    @type metadata() :: %{event: atom()}

    @type t :: %__MODULE__{
            journal_entry_uuid: binary(),
            debit: account_entries(),
            credit: account_entries(),
            metadata: metadata
          }

    defstruct [:journal_entry_uuid, :debit, :credit, :metadata]
  end

  defmodule AccountOpened do
    @type t :: %__MODULE__{user_id: integer()}

    defstruct [:user_id]
  end

  defmodule MoneyDeposited do
    @type t :: %__MODULE__{
            user_id: integer(),
            amount: integer()
          }

    defstruct [:user_id, :amount]
  end

  defmodule MoneyWithdrawn do
    @type t :: %__MODULE__{
            user_id: integer(),
            amount: integer()
          }

    defstruct [:user_id, :amount]
  end
end
