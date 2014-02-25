class Celebrity::ProductAccessory < ActiveRecord::Base
  attr_accessible :celebrity_id, :spree_product_id
  attr_accessible :title, :source, :position, :image

  belongs_to :celebrity
  belongs_to :product, class_name: 'Spree::Product', foreign_key: :spree_product_id

  has_attached_file :image,
    styles: { product: "200x200#", thumbnail: "100x100#" },
    default_style: :product,
    default_url:   :default_image_for_accessory

  scope :active, where(active: true)
  scope :for_product, lambda {|product| where(spree_product_id: product.id) }
  scope :for_product_id, lambda {|product_id| where(spree_product_id: product_id) }

  def default_image_for_accessory
    '/assets/_sample/category-grey-2.jpg'
  end
end
