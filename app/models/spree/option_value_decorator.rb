Spree::OptionValue.class_eval do
  scope :none,    -> { where(id: nil) }
  scope :colors,  -> { where("option_type_id is not null").where(option_type_id: Spree::OptionType.color.try(:id)) }
  scope :sizes,   -> { where("option_type_id is not null").where(option_type_id: Spree::OptionType.size.try(:id)) }

  attr_accessible :value

  before_save :set_type

  # discount
  def discount
    return @discount if instance_variable_defined?('@discount')
    @discount = Repositories::Discount.read('Spree::OptionValue', self.id)
  end

  def set_type
    return if self.type.present? || self.option_type_id.blank?
    case self.option_type_id
    when Spree::OptionType.color.try(:id)
      self.type = Spree::OptionValue::ProductColor.to_s
    when Spree::OptionType.size.try(:id)
      self.type = Spree::OptionValue::ProductSize.to_s
    else
      self.type = Spree::OptionValue.to_s
    end
  end
end
