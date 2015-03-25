
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

    has_attached_file :attachment,
                      :styles => { :product => '240x240>', :large => '600x600>' },
                      :default_style => :product,
                      :url => Spree::Config.attachment_url,
                      :path => Spree::Config.attachment_path
  end
end
