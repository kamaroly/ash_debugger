defmodule TransferTest do
  alias AshDebugger.Ledger.Transfer
  alias AshDebugger.Ledger.Account
  use AshDebuggerWeb.ConnCase
  require Ash.Query

  defp create_accounts() do
    attrs = [
      %{
        identifier: "1010",
        account_number: "1010",
        currency: :KES,
        name: "NCBA Bank"
      },
      %{
        identifier: "1020",
        account_number: "1020",
        currency: :KES,
        name: "M-Pesa"
      }
    ]

    Ash.Seed.seed!(Account, attrs)
  end

  describe "Reproduce Ash Double Entry Jason Error" do
    test "Transfer should work from one account to another" do
      accounts = create_accounts()
      account_1 = Enum.at(accounts, 0)
      account_2 = Enum.at(accounts, 1)

      attrs = %{
        amount: Money.new!(20, :KES),
        from_account_id: account_1.id,
        to_account_id: account_2.id
      }

      {:ok, _transfer} =
        Transfer
        |> Ash.Changeset.for_create(:transfer, attrs)
        |> Ash.create()

      assert Account
             |> Ash.Query.filter(id == ^account_2.id)
             |> Ash.Query.filter(balance_as_of == ^attrs.amount)
             |> Ash.exists?()
    end
  end
end
