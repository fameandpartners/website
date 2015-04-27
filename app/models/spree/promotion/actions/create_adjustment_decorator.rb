Spree::Promotion::Actions::CreateAdjustment.class_eval do

#  original
#  # Creates the adjustment related to a promotion for the order passed
#  # through options hash
#  def perform(options = {}) 
#    order = options[:order]
#    return if order.promotion_credit_exists?(self.promotion)
#
#    self.create_adjustment("#{I18n.t(:promotion)} (#{promotion.name})", order, order)
#  end 
 
  def perform(options = {})
    order = options[:order]
    return if order.promotion_action_credit_exists?(self)

    self.create_adjustment("#{I18n.t(:promotion)} (#{promotion.name})", order, order)
  end
end
