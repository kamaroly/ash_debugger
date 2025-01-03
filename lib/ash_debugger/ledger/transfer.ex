defmodule AshDebugger.Ledger.Transfer do
  use Ash.Resource,
    domain: AshDebugger.Ledger,
    data_layer: AshPostgres.DataLayer,
    notifiers: [Ash.Notifier.PubSub],
    extensions: [AshDoubleEntry.Transfer, AshPaperTrail.Resource]

  postgres do
    table "ledger_transfers"
    repo AshDebugger.Repo
  end

  transfer do
    # configure the other resources it will interact with
    account_resource(AshDebugger.Ledger.Account)
    balance_resource(AshDebugger.Ledger.Balance)

    # you only need this if you are using `postgres`
    # and so cannot add the `references` block shown below

    destroy_balances?(true)
  end

  paper_trail do
    # default is false
    store_action_name?(true)
  end

  pub_sub do
    module AshDebuggerWeb.Endpoint

    prefix "ledger_transfers"
    publish_all :update, [[:id, nil]]
    publish_all :create, [[:id, nil]]
    publish_all :destroy, [[:id, nil]]
  end

  multitenancy do
    strategy :context
  end
end
