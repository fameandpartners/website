Spree::Payment.class_eval do

  #has_many :quad_pay_orders
  attr_accessor :response_code

  def gateway_options
    options = { :email    => order.email,
                :customer => order.email,
                :ip       => order.last_ip_address,
                # Need to pass in a unique identifier here to make some
                # payment gateways happy.
                #
                # For more information, please see Spree::Payment#set_unique_identifier
                :order_id => gateway_order_id }

    options.merge!({ :shipping => order.ship_total * 100,
                     :tax      => order.tax_total * 100,
                     :subtotal => order.item_total * 100 })

    options.merge!({ :currency => currency })

    options.merge!({ :billing_address  => order.bill_address.try(:active_merchant_hash),
                     :shipping_address => order.ship_address.try(:active_merchant_hash) })

    options.merge!(:discount => promo_total) if respond_to?(:promo_total)

    options.merge!(:description => "Order ##{gateway_order_id}")

    options
  end

  def quadpay_order
    if response_code && !response_code.blank?
      Spree::QuadpayOrder.where(qp_order_id: response_code)&.first
    elsif source_type == "Spree::QuadpayOrder" && source_id
      qp_order = Spree::QuadpayOrder.find(source_id)
      if qp_order
        update_attributes({:response_code => qp_order.qp_order_id}, :without_protection => true)
      end
    else
      nil
    end
  end
  def update_qp_order_id
    if (!response_code || response_code.blank?) && source_type == "Spree::QuadpayOrder" && source_id
      qp_order = Spree::QuadpayOrder.find(source_id)
      if qp_order
        update_attributes({:response_code => qp_order.qp_order_id}, :without_protection => true)
      end
    end
  end
end
