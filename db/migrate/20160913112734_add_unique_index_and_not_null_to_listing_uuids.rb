class AddUniqueIndexAndNotNullToListingUuids < ActiveRecord::Migration[5.1]
  def change
    change_column_null :listings, :uuid, false
    add_index :listings, :uuid, unique: true
  end
end
