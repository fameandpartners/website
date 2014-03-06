class ProductVideo < ActiveRecord::Base
  belongs_to :product, class_name: 'Spree::Product', foreign_key: :spree_product_id
  belongs_to :color, class_name: 'Spree::OptionValue', foreign_key: :spree_option_value_id

  attr_accessible :url, :video_id, :spree_product_id, :position, :color_name, :is_master, :spree_option_value_id

  scope :master, where(is_master: true)
  default_scope order('position asc')

  def video_url
    self.url.present? ? self.url : generate_url_by_id
  end

  def generate_url_by_id
    "http://player.vimeo.com/video/#{self.video_id}?title=0&byline=0&portrait=0&autoplay=0&loop=1"
  end
end
