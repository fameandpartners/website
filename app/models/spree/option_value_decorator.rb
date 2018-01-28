Spree::OptionValue.class_eval do
  has_many :product_color_values, dependent: :destroy
  has_many :similarities,
           inverse_of: :original,
           foreign_key: :original_id
  has_many :similars,
           through: :similarities,
           order: 'similarities.coefficient asc'
  has_many :discounts, as: :discountable

  has_and_belongs_to_many :option_values_groups,
                          class_name: 'Spree::OptionValuesGroup'

  has_attached_file :image, styles: {
    mini: '48x48#', small: '100x100>', small_square: '100x100#', medium: '240x240>'
  }

  scope :none,    -> { where(id: nil) }
  scope :colors,  -> { where("option_type_id is not null").where(option_type_id: Spree::OptionType.color.try(:id)) }
  scope :sizes,   -> { where("option_type_id is not null").where(option_type_id: Spree::OptionType.size.try(:id)) }

  attr_accessible :image, :value, :use_in_customisation

  def rgb_values
    # Color::HEX.new(value.to_s).to_lab
    @rgb_values ||= value.to_s.scan(/[0-9a-zA-Z]{2}/).map{|v| v.to_i(16)}
  end

  # hsv representation
  def hsv_value
    @hsv_value ||= (rgb_values.present? ? rgb_values.max : 1)
  end

  # discount
  def discount
    return @discount if instance_variable_defined?('@discount')
    @discount = Repositories::Discount.read(self.class, self.id)
  end

  # some good ole hackery for swatches
  def image_file_name_for_swatch
    image_file_name ? "#{configatron.asset_host}/assets/product-color-images/#{image_file_name}" : nil
  end
end
