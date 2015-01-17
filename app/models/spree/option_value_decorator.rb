Spree::OptionValue.class_eval do
  has_many :product_color_values, dependent: :destroy
  has_many :similarities,
           inverse_of: :original,
           foreign_key: :original_id
  has_many :similars,
           through: :similarities,
           order: 'similarities.coefficient asc'
  has_many :discounts, as: :discountable

  has_attached_file :image, styles: {
    mini: '48x48#', small: '100x100>', small_square: '100x100#', medium: '240x240>'
  }

  scope :none, where(id: nil)

  attr_accessible :image, :value, :use_in_customisation
  validates :value, format: /^#([0-9a-f]{3}|[0-9a-f]{6})$/i, allow_blank: true

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

  class << self
    def colors
      if (option_type = Spree::OptionType.color).present?
        where(option_type_id: option_type.id)
      else
        []
      end
    end
  end
end
