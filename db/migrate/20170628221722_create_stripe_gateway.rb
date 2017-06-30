class CreateStripeGateway < ActiveRecord::Migration
  def up
    gateway = Spree::Gateway.new
    gateway.type = "Spree::Gateway::Stripe"
    gateway.name = "Stripe Payments"
    gateway.description = "Real payment processor"
    gateway.active = true
    gateway.save
  end

  def down
    #this is wonky
    Spree::PaymentMethod.connection.execute("DELETE FROM spree_payment_methods where name = 'Stripe Payments'")
  end
end
