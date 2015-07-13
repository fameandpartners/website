# we can find suitable shipping method
#   - by shipping address [ order.address -> country -> zone -> shipping methods ]
#   - by site version [ order -> user -> site_version -> zone -> shipping methods ]]
#   - by product shipping category
#
module Services; end
class Services::FindShippingMethodForOrder
  def initialize(order)
    @order = order
  end

  def get
    result = nil
    result = zone.shipping_methods.ordered.first if zone.present?
    result ||= shipping_category.shipping_methods.ordered.first if shipping_category.present?
    result ||= Spree::ShippingMethod.ordered.first
    result
  rescue Exception => e
    nil
  end

  private

  def zone
    @zone ||= get_zone
  end

  def get_zone
    zone ||= get_zone_by_shipping_address
    zone ||= get_zone_by_user_site_version
    zone
  end

  def get_zone_by_shipping_address
    address = @order.shipping_address
    return nil if address.blank? or address.country.blank?

    zone_member = Spree::ZoneMember.where(zoneable_type: 'Spree::Country', zoneable_id: address.country_id).first
    if zone_member.blank? && address.state_id.present?
      zone_member = Spree::ZoneMember.where(zoneable_type: 'Spree::State', zoneable_id: address.state_id).first
    end
    zone_member.try(:zone)
  end

  def get_zone_by_user_site_version
    if @order.user && (site_version = @order.user.recent_site_version).present?
      site_version.zone
    else
      # no user or no site version... empty zone
      nil
    end
  end

  def shipping_category
    @shipping_category ||= @order.line_items.includes(product: :shipping_category).map{|t| t.product.shipping_category}.compact.first
  end
end
