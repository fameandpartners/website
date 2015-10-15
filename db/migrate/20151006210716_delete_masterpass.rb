class DeleteMasterpass < ActiveRecord::Migration
  def up
    Spree::Payment.where(source_type: 'Spree::MasterpassCheckout').each do |payment|
      Spree::Order.find(payment.order_id).destroy
    end
  end

  def down
  end
end
