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

    has_attached_file :attachment,
                      :styles => { :mini => '48x48>', :small => '100x100>', :product => '240x240>', :large => '600x600>' },
                      :default_style => :product,
                      :url => '/spree/products/:id/render3d/:style/:basename.:extension',
                      :path => ':rails_root/public/spree/products/render3d/:id/:style/:basename.:extension',
                      :convert_options => { :all => '-strip -auto-orient' }

    include Spree::Core::S3Support
    supports_s3 :attachment
  end
end
