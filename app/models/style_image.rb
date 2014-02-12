class StyleImage < ActiveRecord::Base
  attr_accessible :image, :position
  belongs_to :style
  default_scope order('position ASC')

  has_attached_file :image,
    styles: { product: "375x480#", thumbnail: "187x240#" },
    default_style: :product,
    default_url:   :default_image_for_style

  def default_image_for_style
    '/assets/_sample/category-grey-2.jpg'
  end
end
