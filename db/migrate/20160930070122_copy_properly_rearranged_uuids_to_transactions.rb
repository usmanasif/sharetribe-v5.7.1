class CopyProperlyRearrangedUuidsToTransactions < ActiveRecord::Migration[5.1]
  def up
    execute "UPDATE transactions, listings SET transactions.listing_uuid = listings.uuid WHERE transactions.listing_id = listings.id"
    execute "UPDATE transactions, communities SET transactions.community_uuid = communities.uuid WHERE transactions.community_id = communities.id"
  end
end
