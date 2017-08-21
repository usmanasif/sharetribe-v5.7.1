class AddAvailabilityToListingsAndTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :listings, :availability, :string, limit: 32, default: :none
    add_column :transactions, :availability, :string, limit: 32, default: :none, after: :shipping_price_cents
  end
end
