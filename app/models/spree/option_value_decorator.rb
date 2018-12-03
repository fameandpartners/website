Spree::OptionValue.class_eval do
  has_many :product_color_values, dependent: :destroy
  has_many :similarities,
           inverse_of: :original,
           foreign_key: :original_id
  has_many :similars,
           through: :similarities,
           order: 'similarities.coefficient asc'
  has_many :discounts, as: :discountable

  has_many :fabrics

  has_and_belongs_to_many :option_values_groups,
                          class_name: 'Spree::OptionValuesGroup'

  has_attached_file :image, styles: {
    mini: '48x48#', small: '100x100>', small_square: '100x100#', medium: '240x240>'
  }

  scope :none,    -> { where(id: nil) }
  scope :colors,  -> { where("option_type_id is not null").where(option_type_id: Spree::OptionType.color.try(:id)) }
  scope :fabrics,  -> { where("option_type_id is not null").where(option_type_id: Spree::OptionType.fabric_color.try(:id)) }
  scope :sizes,   -> { where("option_type_id is not null").where(option_type_id: Spree::OptionType.size.try(:id)) }

  attr_accessible :image, :value, :use_in_customisation

  def color_hex
		value&.include?("#") ? value : nil
  end
  
  def color_image
    file_name = image_file_name || value
    return nil if file_name.starts_with?('#')


    "#{configatron.asset_host}/assets/product-color-images/#{file_name}"
  end

  # discount
  def discount
    @discount ||= discounts.active.first
  end
end
