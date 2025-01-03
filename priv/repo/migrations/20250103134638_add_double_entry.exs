defmodule AshDebugger.Repo.Migrations.AddDoubleEntry do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:Tenants, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("uuid_generate_v7()"), primary_key: true
      add :domain, :text, null: false

      add :inserted_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")
    end

    create unique_index(:Tenants, [:domain], name: "Tenants_unique_domain_index")
  end

  def down do
    drop_if_exists unique_index(:Tenants, [:domain], name: "Tenants_unique_domain_index")

    drop table(:Tenants)
  end
end
