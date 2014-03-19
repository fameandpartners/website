Spree::ShipmentMailer.class_eval do
  add_template_helper(OrdersHelper)
end
