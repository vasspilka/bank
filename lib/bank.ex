defmodule Bank do
  @moduledoc "Banking application"

  @type account_number() :: binary()
  @type amount() :: integer()
  @type account_entries() :: %{account_number() => amount()}
end
