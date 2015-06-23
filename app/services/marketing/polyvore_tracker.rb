module Marketing; end

class Marketing::PolyvoreTracker
  include ActionView::Helpers::NumberHelper

  attr_reader :order, :site_version, :order_id

  def initialize(order, site_version)
    @order = order
    @site_version = site_version

    @order_id = @order.number
  end

  def retailer_host_name
    'fameandpartners.com'
  end

  def subtotal
    total = order.total

    if site_version.is_australia?
      total = (total / 1.1) #remove gst component
    end

    number_to_currency(total, :unit => '')
  end

  def skus
   order.line_items.collect{ |item| item.variant.sku || item.variant.product.sku }.join(',')
  end

  def currency
    site_version.currency
  end

  def url
    "//www.polyvore.com/conversion/beacon.gif?adv=#{retailer_host_name}&amt=#{subtotal}&oid=#{order_id}&skus=#{skus}&cur=#{currency}"
  end

end
