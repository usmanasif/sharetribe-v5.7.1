class HideExpirationDateByDefault < ActiveRecord::Migration[5.1]

  def up
    change_column_default(:communities, :hide_expiration_date, true)
  end

  def down
    change_column_default(:communities, :hide_expiration_date, false)
  end

end
