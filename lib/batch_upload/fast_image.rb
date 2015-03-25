
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

    include Spree::Core::S3Support
    supports_s3 :attachment

    Spree::Image.attachment_definitions[:attachment][:path] = Spree::Config[:attachment_path]
    Spree::Image.attachment_definitions[:attachment][:url] = Spree::Config[:attachment_url]
    Spree::Image.attachment_definitions[:attachment][:default_url] = Spree::Config[:attachment_default_url]
    Spree::Image.attachment_definitions[:attachment][:default_style] = Spree::Config[:attachment_default_style]
  end
end
