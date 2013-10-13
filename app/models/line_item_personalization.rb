class LineItemPersonalization < ActiveRecord::Base
  COLORS = %w( #ED0234 #E3D0C5 #15558B #FF3B9D #FF8434 #FFE100 #269C36 #FFC598 #D0D1CC )
  default_value_for :customization_value_ids, []

  serialize :customization_value_ids, Array

  belongs_to :product,
             class_name: 'Spree::Product'
  belongs_to :line_item,
             class_name: 'Spree::LineItem'

  attr_accessible :body_shape_id,
                  :customization_value_ids,
                  :height,
                  :size,
                  :color

  validates :body_shape_id,
            presence: true,
            inclusion: {
              allow_blank: true,
              in: 0...PersonalizationSettings::BODY_SHAPES.size
            }

  validates :height,
            presence: true,
            numericality: {
              allow_blank: true,
              only_integer: true,
              greater_than_or_equal_to: 1
            }

  validates :size,
            presence: true,
            inclusion: {
              allow_blank: true,
              in: PersonalizationSettings::SIZES
            }

  validates :color,
            presence: true,
            format: {
              allow_blank: true,
              with: /^#(?:[0-9a-fA-F]{3}){1,2}$/
            }

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

  def color_picker?
    color.present? && !COLORS.include?(color)
  end

  def customization_values
    CustomisationValue.find(customization_value_ids)
  end

  def customization_types
    CustomisationType.find(customization_values.map(&:customisation_type_id)).uniq
  end

  def customization_value_ids=(hash)
    super(hash.values.flatten.map(&:to_i)) if hash.is_a?(Hash)
  end

  def body_shape
    PersonalizationSettings::BODY_SHAPES[body_shape_id].titleize if body_shape_id.present?
  end

  def options_hash
    values = {}
    values['Size'] = size
    values['Height'] = height
    values['Body Shape'] = body_shape
    values['Color'] = color if color.present?


    CustomisationValue.includes(:customisation_type).find(customization_value_ids).each do |value|
      values[value.customisation_type.presentation] = value.presentation
    end

    values
  end
end
