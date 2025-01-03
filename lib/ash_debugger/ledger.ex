defmodule AshDebugger.Ledger do
  use Ash.Domain

  resources do
    resource AshDebugger.Ledger.Account
    resource AshDebugger.Ledger.Transfer
    resource AshDebugger.Ledger.Balance
  end
end
