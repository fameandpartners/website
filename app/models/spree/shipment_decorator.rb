require 'ostruct'

Spree::Shipment.class_eval do
  def is_dhl?
    self.shipping_method.name.match(/dhl/i).present?
  end

  def is_auspost?
    self.shipping_method.name.match(/auspost/i).present?
  end
end
