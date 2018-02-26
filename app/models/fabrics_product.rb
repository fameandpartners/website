class FabricsProduct < ActiveRecord::Base
  attr_accessible :fabric, :product_id, :fabric_id, :recommended, :description

  belongs_to :product, class_name: 'Spree::Product'

  belongs_to :fabric, class_name: 'Fabric'

  has_many :images, as: :viewable, order: :position, dependent: :destroy, class_name: "Spree::Image"

  validates :product_id, :fabric_id, presence: true

  def recommended?
    ! recommended?
  end

  def color_name
    fabric.option_value.name
  end

  def color_id
    fabric.option_value.id
  end

  def self.recommended
    where(recommended: true)
  end

  def self.custom
    where(recommended: false)
  end
end
