module Render3d
  class Image < ActiveRecord::Base
    belongs_to :product, class_name: 'Spree::Product'
    belongs_to :customisation_value
    belongs_to :product_color_value

    validates :customisation_value,
              :product_color_value,
              :product,
              presence: true

    validates_attachment_presence :attachment
    attr_accessible :attachment
    has_attached_file :attachment

    self.attachment_definitions[:attachment] = Paperclip::Attachment.default_options

    self.attachment_definitions[:attachment][:path]   = 'spree/products/render3d/:id/:style/:basename.:extension'
    self.attachment_definitions[:attachment][:styles] = { product: '240x240>', large: '600x600>' }
    self.attachment_definitions[:attachment][:default_style] = :product
    self.attachment_definitions[:attachment][:convert_options] = { :all => '-strip -auto-orient' }
  end
end
