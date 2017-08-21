class AddFeaturedColumnToListing < ActiveRecord::Migration[5.1]
  def change
  	unless column_exists?(:listings, :featured)
    	add_column :listings, :featured, :boolean, default: false
  	end
  end
end
	