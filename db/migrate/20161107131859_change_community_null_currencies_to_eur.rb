class ChangeCommunityNullCurrenciesToEur < ActiveRecord::Migration[5.1]
  def up
    sql = 'UPDATE communities c
           SET c.currency = "EUR"
           WHERE c.currency IS NULL'
    exec_update(sql, "Change NULL currencies to EUR", [])
  end
end
