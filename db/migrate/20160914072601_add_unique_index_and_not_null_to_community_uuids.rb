class AddUniqueIndexAndNotNullToCommunityUuids < ActiveRecord::Migration[5.1]
  def change
    change_column_null :communities, :uuid, false
    add_index :communities, :uuid, unique: true
  end
end
