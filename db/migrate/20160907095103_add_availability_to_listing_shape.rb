class AddAvailabilityToListingShape < ActiveRecord::Migration[5.1]
  def change
    add_column :listing_shapes, :availability, :string, limit: 32, default: "none", after: :shipping_enabled
  end
end
