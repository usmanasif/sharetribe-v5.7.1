class RemoveCheckoutPaymentGateway < ActiveRecord::Migration[5.1]
  def up
    execute("
      DELETE FROM payment_gateways WHERE type = 'Checkout'
    ")
  end

  def down
    # Nothing here
  end
end
