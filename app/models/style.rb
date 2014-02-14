class Style < ActiveRecord::Base
  attr_accessible :name, :title

  validates :name, presence: true, inclusion: ProductStyleProfile::BASIC_STYLES

  has_many :product_accessories

  def title
    super || "#{self.name.to_s.upcase} LOOK"
  end
end
