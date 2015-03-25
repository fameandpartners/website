
module BatchUpload
  class FastImage < ActiveRecord::Base
    self.table_name = 'spree_assets'

    attr_accessible :viewable_type,
                    :viewable_id,
                    :position,
                    :type,
                    :attachment,
                    :attachment_width,
                    :attachment_height

    ATTACHMENT_URL  = '/spree/products/:id/:style/:basename.:extension',

    if Rails.env.production?
      ATTACHMENT_PATH = '/spree/products/:id/:style/:basename.:extension'
    else
      ATTACHMENT_PATH = ':rails_root/public/spree/products/:id/:style/:basename.:extension'
    end

    has_attached_file :attachment,
                      :styles => { :product => '240x240>', :large => '600x600>' },
                      :default_style => :product,
                      :url => ATTACHMENT_URL,
                      :path => ATTACHMENT_PATH
  end
end
