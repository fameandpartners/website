Spree::OptionValue.class_eval do
  has_many :product_color_values, dependent: :destroy

  has_many :similarities,
           inverse_of: :original,
           foreign_key: :original_id
  has_many :similars,
           through: :similarities


  has_attached_file :image, styles: {
    mini: '48x48#', small: '100x100>', small_square: '100x100#', medium: '240x240>'
  }

  scope :none, where(id: nil)

  attr_accessible :image, :value
  validates :value, format: /^#([0-9a-f]{3}|[0-9a-f]{6})$/i, allow_blank: true
end
