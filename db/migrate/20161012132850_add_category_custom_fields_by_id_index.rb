class AddCategoryCustomFieldsByIdIndex < ActiveRecord::Migration[5.1]
  def change
  	add_index :category_custom_fields, [:custom_field_id]
  end
end
