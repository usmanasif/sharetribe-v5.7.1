class AddLimitSearchDistanceToMarketplaceConfigurations < ActiveRecord::Migration[5.1]
  def change
    add_column :marketplace_configurations, :limit_search_distance, :boolean, default: true, null: false
  end
end
