class LineItemPersonalization < ActiveRecord::Base
  default_value_for :customization_value_ids, []

  serialize :customization_value_ids, Array

  belongs_to :product,
             class_name: 'Spree::Product'
  belongs_to :line_item,
             class_name: 'Spree::LineItem'
  belongs_to :color,
             class_name: 'Spree::OptionValue'

  attr_accessible :customization_value_ids,
                  :height,
                  :size,
                  :color_id, :color_name

  validates :size,
            presence: true,
            inclusion: {
              allow_blank: true,
              in: [4, 6, 8, 10, 12, 14, 16, 18, 20]
            }

  validates :color,
            presence: true

  attr_accessor :color_name
  before_validation :set_color_by_name
  before_save :recalculate_price

  validate do
    if product.present? && customization_value_ids.present?
      unless customization_value_ids.all?{ |id| product.product_customisation_values.map(&:customisation_value_id).include?(id) }
        errors.add(:base, 'Some customisation options can not be selected')
      end
    end
  end

  validate do
    if product.present? && customization_value_ids.present?
      unless customization_values.count.eql?(customization_types.count)
        errors.add(:base, 'Invalid customisation options selected')
      end
    end
  end

#  def color
#    if attributes['color'].present?
#      attributes['color']
#    elsif super.present?
#      super.presentation
#    else
#      nil
#    end
#  end

#  def color_picker?
#    color.present? && !COLORS.include?(color)
#  end

  def customization_values
    CustomisationValue.includes(:customisation_type).find(customization_value_ids)
  end

  def customization_types
    customization_values.map(&:customisation_type).uniq
  end

  def customization_value_ids=(hash)
    super(hash.values.flatten.map(&:to_i)) if hash.is_a?(Hash)
  end

  def options_hash
    values = {}
    values['Size'] = size
    values['Color'] = color if color.present?

    customization_values.each do |value|
      values[value.customisation_type.presentation] = value.presentation
    end

    values
  end

  def set_color_by_name
    if @color_name.present? and color.blank? and product.present?
      self.color = product.basic_colors.where(name: @color_name).first
      self.color ||=  product.custom_colors.where(name: @color_name).first
    end
    return true
  end

  # calculate additional cost
  #   - custom color costs addional 16$ in current currency
  def recalculate_price
    self.price = 0.0
    self.price += 16.0 if !basic_color?
    self.price
  rescue
    self.price = 0.0
  end

  def basic_color?
    return false if product.blank? || color.blank?

    product.basic_colors.where(id: color_id).exists?
  end
end
