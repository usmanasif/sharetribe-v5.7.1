class AddNightSelectorToListingsWithNightUnit < ActiveRecord::Migration[5.1]
  def up
    exec_update("UPDATE listings SET quantity_selector = 'night' WHERE unit_type = 'night'", "Listings quantity selector", [])
  end

  def down
    exec_update("UPDATE listings SET quantity_selector = 'number' WHERE unit_type = 'night'", "Listings quantity selector", [])
  end
end
