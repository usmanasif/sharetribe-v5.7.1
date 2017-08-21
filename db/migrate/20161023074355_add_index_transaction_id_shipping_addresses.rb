class AddIndexTransactionIdShippingAddresses < ActiveRecord::Migration[5.1]
  def change
  	add_index :shipping_addresses, [:transaction_id]
  end
end
