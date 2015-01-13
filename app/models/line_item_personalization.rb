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
                  :color_id,
                  :color_name

  validates :size,
            presence: true,
            inclusion: {
              allow_blank: true,
              in: [0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26]
            }

  validates :color,
            presence: true

  attr_accessor :color_name
  before_validation :set_color_by_name
  before_save :recalculate_price

  after_save do
    line_item.order.clean_cache!
  end

  after_destroy do
    line_item.order.clean_cache!
  end

  validate do
    if product.present? && customization_value_ids.present?
      unless customization_value_ids.all?{ |id| product.customisation_value_ids.include?(id.to_i) }
        errors.add(:base, 'Some customisation options can not be selected')
      end

      customization_values.includes(:incompatibles).each_with_index do |customization_value, index|
        unless customization_values.to_a.from(index + 1).all?{ |cv| cv.is_compatible_with?(customization_value) }
          errors.add(:base, 'Some customisation options can not be selected')
        end
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
    @customization_values ||= CustomisationValue.where(id: customization_value_ids)
  end

  #def customization_value_ids=(hash)
  #  super(hash.values.flatten.map(&:to_i)) if hash.is_a?(Hash)
  #end

  def options_hash
    values = {}
    values['Size'] = size
    values['Color'] = color.presentation if color.present?

    customization_values.each do |value|
      values[value.presentation] = nil
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
  # custom color costs addional $16 in current currency
  def recalculate_price
    self.price = calculate_price
  end

  def calculate_price
    result = 0.0

    result += calculate_size_cost(20.0)
    result += calculate_color_cost(16.0)

    customization_values.each do |customization_value|
      result += calculate_customization_value_cost(customization_value)
    end

    result
  end

  # Size Pricing
  def calculate_size_cost(default_extra_size_cost = 20.0)
    add_plus_size_cost? ? default_extra_size_cost : 0
  end

  def add_plus_size_cost?
    if plus_size? == nil
      if size && size.to_i >= locale_plus_sizes
        return true
      end
    end
  end

  def locale_plus_sizes
    order.get_site_version.size_settings.size_charge_start
  rescue
    14
  end

  def plus_size?
    return true if !product.blank? && product.taxons.where(:name => "Plus Size").count > 0
  end
  # eo size pricing

  # Color pricing
  def calculate_color_cost(default_custom_color_cost = 16.0)
    if product.present? && color.present?
      if basic_color?
        return 0
      else
        if color.discount.present?
          Spree::Price.new(amount: default_custom_color_cost).apply(color.discount).price
        else
          default_custom_color_cost
        end
      end
    else
      0
    end
  end

  def basic_color?
    product.basic_colors.where(id: color_id).exists?
  end

  # customization value cost
  def calculate_customization_value_cost(customization_value)
    discount = customization_value.discount
    if discount.present?
      Spree::Price.new(amount: customization_value.price).apply(discount).price
    else
      customization_value.price
    end
  end
end
