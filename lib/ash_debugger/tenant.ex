defmodule AshDebugger.Tenant do
  use Ash.Resource,
    domain: AshDebugger.Ledger,
    data_layer: AshPostgres.DataLayer

  defimpl Ash.ToTenant do
    def to_tenant(resource, %{:domain => domain, :id => id}) do
      if Ash.Resource.Info.data_layer(resource) == AshPostgres.DataLayer &&
           Ash.Resource.Info.multitenancy_strategy(resource) == :context do
        domain
      else
        id
      end
    end
  end

  postgres do
    table "Tenants"
    repo AshDebugger.Repo

    manage_tenant do
      template ["", :domain]
      create? true
      update? false
    end
  end

  actions do
    default_accept [:domain]
    defaults [:create, :read, :destroy]
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :domain, :string, allow_nil?: false, public?: true
    timestamps()
  end

  identities do
    identity :unique_domain, [:domain]
  end
end
