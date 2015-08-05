Spree::ShippingMethod.class_eval do
  scope :ordered, order('position asc')

  before_create :assign_position

  def assign_position
    self.position ||= Spree::ShippingMethod.maximum(:position).to_i.next
  end
end
