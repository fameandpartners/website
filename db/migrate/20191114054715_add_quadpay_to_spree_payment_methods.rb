class AddQuadpayToSpreePaymentMethods < ActiveRecord::Migration
  def up
    execute(add_quadpay_to_spree_payment_method)
  end
  private def add_quadpay_to_spree_payment_method
    <<-SQL
    INSERT INTO spree_payment_methods (type, NAME,description,active,environment,deleted_at,created_at,updated_at,display_on) VALUES ('Spree::Gateway::QuadpayPayment','USD Quadpay Payments PROD',NULL,TRUE,'production',NOW(),NOW(),NOW(),NULL)
    SQL
  end
end
