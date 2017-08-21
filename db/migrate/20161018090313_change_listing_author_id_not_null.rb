class ChangeListingAuthorIdNotNull < ActiveRecord::Migration[5.1]
  def change
    change_column_null :transactions, :listing_author_id, false
  end
end
