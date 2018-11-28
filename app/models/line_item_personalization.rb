class LineItemPersonalization < ActiveRecord::Base
  default_value_for :customization_value_ids, []

  serialize :customization_value_ids, Array

  belongs_to :product,
             class_name: 'Spree::Product'
  belongs_to :line_item,
             class_name: 'Spree::LineItem'
  belongs_to :color,
             class_name: 'Spree::OptionValue'
  belongs_to :size,
             class_name: 'Spree::OptionValue'

  attr_accessible :customization_value_ids,
                  :height,
                  :size_id,
                  :color_id,
                  :sku

  validates :size, :color,  presence: true

  DEFAULT_HEIGHT = 'standard'
  HEIGHTS = %w(petite standard tall length1 length2 length3 length4 length5 length6) #Make sure first letter+ last letter of Heights is unique otherwise skus will not be generated correctly
  validates :height, inclusion: { in: HEIGHTS }

  DEFAULT_CUSTOM_SIZE_PRICE   = BigDecimal.new('20.0')
  DEFAULT_CUSTOM_COLOR_PRICE  = BigDecimal.new('16.0')

  before_save :recalculate_price

  validate do
    if product.present? && customization_value_ids.present?
      unless customization_value_ids.all?{ |id| product.customisation_value_ids.include?(id.to_i) }
        errors.add(:base, 'Some customisation options can not be selected')
      end

      #TODO: Update this code when we actually imploment incompatibilities
    end
  end

  def customization_values
    @customization_values ||=  self.line_item.customizations.nil? ? JSON.parse(CustomisationValue.where(id: customization_value_ids).to_json) : JSON.parse(self.line_item.customizations)
  end

  def options_hash
    values = {}
    values['Size'] = size.presentation if size.present?
    values['Color'] = color.presentation if color.present?
    customization_values
      .sort_by { |x| x['customisation_value']['manifacturing_sort_order']}
      .each do |customization_value|
        value = customization_value['customisation_value']
        values[value['presentation']] = nil
      end

    values
  end

  # calculate additional cost
  # for custom color, price, and personalizations itself
  def recalculate_price
    self.price = calculate_price
  end

  def calculate_price
    size_cost + color_cost + customizations_cost
  end

  def size_cost
    calculate_size_cost(LineItemPersonalization::DEFAULT_CUSTOM_SIZE_PRICE)
  end

  def color_cost
    calculate_color_cost(LineItemPersonalization::DEFAULT_CUSTOM_COLOR_PRICE)
  end

  def customizations_cost
    result = BigDecimal.new(0)
    customization_values.each do |customization_value|
      result += calculate_customization_value_cost(customization_value['customisation_value'])
    end
    result
  end

  # Size Pricing
  def calculate_size_cost(default_extra_size_cost = LineItemPersonalization::DEFAULT_CUSTOM_SIZE_PRICE)
    BigDecimal.new(0)
  end

  # Color pricing
  def calculate_color_cost(default_custom_color_cost = LineItemPersonalization::DEFAULT_CUSTOM_COLOR_PRICE)
    if product.present? && color.present?
      if basic_color?
        return BigDecimal.new(0)
      else
        if color.discount.present?
          Spree::Price.new(amount: default_custom_color_cost).apply(color.discount).price
        else
          default_custom_color_cost
        end
      end
    else
      BigDecimal.new(0)
    end
  end

  # TODO: since we get Product#basic_colors via Product#basic_color_ids probably it's better to use #basic_color_ids here
  # Nickolay 2016-01-05
  def basic_color?
    product.basic_colors.where(id: color_id).exists?
  end

  # customization value cost
  def calculate_customization_value_cost(customization_value)
    discount = customization_value['discount']
    if discount.present?
      Spree::Price.new(amount: customization_value['price'].to_f).apply(discount.to_f).price #TODO: This is probably broken
    else
      customization_value['price'].to_f
    end
  end

  def height
    read_attribute(:height).presence || DEFAULT_HEIGHT
  end

  def default_height?
    height == DEFAULT_HEIGHT
  end
end
