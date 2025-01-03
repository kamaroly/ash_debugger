defmodule AshDebugger.Ledger do
  use Ash.Domain, extensions: [AshPaperTrail.Domain]

  paper_trail do
    include_versions?(true)
  end

  resources do
    resource AshDebugger.Tenant

    resource AshDebugger.Ledger.Account
    resource AshDebugger.Ledger.Transfer
    resource AshDebugger.Ledger.Balance
  end
end
