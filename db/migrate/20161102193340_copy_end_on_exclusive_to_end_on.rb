class CopyEndOnExclusiveToEndOn < ActiveRecord::Migration[5.1]
  def up
    name = "Copy end_on_exclusive to end_on"
    sql = "UPDATE bookings SET end_on = end_on_exclusive"

    exec_update(sql, name, [])
  end

  def down
    name = "Rollback copy end_on_exclusive to end_on"
    sql = "UPDATE bookings SET end_on_exclusive = end_on"

    exec_update(sql, name, [])
  end
end
