class AddNotNullToTransactionUuids < ActiveRecord::Migration[5.1]
  def change
    change_column_null :transactions, :listing_uuid, false
    change_column_null :transactions, :community_uuid, false
  end
end
