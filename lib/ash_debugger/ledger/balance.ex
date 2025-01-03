defmodule AshDebugger.Ledger.Balance do
  use Ash.Resource,
    domain: AshDebugger.Ledger,
    data_layer: AshPostgres.DataLayer,
    notifiers: [Ash.Notifier.PubSub],
    extensions: [AshDoubleEntry.Balance, AshPaperTrail.Resource]

  postgres do
    table "ledger_balances"
    repo AshDebugger.Repo

    references do
      reference :transfer, on_delete: :delete
    end
  end

  balance do
    # configure the other resources it will interact with
    transfer_resource(AshDebugger.Ledger.Transfer)
    account_resource(AshDebugger.Ledger.Account)
  end

  paper_trail do
    # default is false
    store_action_name?(true)
  end

  actions do
    read :read do
      primary? true
      # configure keyset pagination for streaming
      pagination keyset?: true, required?: false
    end
  end

  pub_sub do
    module AshDebuggerWeb.Endpoint

    prefix "ledger_balances"
    publish_all :update, [[:id, nil]]
    publish_all :create, [[:id, nil]]
    publish_all :destroy, [[:id, nil]]
  end

  multitenancy do
    strategy :context
  end
end
