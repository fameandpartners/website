class ProductAccessory < ActiveRecord::Base
  attr_accessible :name, :source, :position, :price, :spree_product_id, :style_id, :image

  belongs_to :style
  belongs_to :product, class_name: 'Spree::Product', foreign_key: :spree_product_id
  
  has_attached_file :image,
    styles: { product: "375x480#", thumbnail: "187x240#" },
    default_style: :product,
    default_url:   :default_image_for_accessory

  scope :active, where(active: true)

  def default_image_for_accessory
    '/assets/_sample/category-grey-2.jpg'
  end

  def display_price(default_currency = 'AUD')
    price_currency = self.currency || default_currency
    Spree::Money.new(price, currency: price_currency)
  end
end
