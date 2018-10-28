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

    has_attached_file :attachment

    self.attachment_definitions[:attachment]                 = Paperclip::Attachment.default_options
    self.attachment_definitions[:attachment][:path]          = 'spree/products/:id/:style/:basename.:extension'
    self.attachment_definitions[:attachment][:styles]        = Spree::Image.attachment_definitions[:attachment][:styles]
    self.attachment_definitions[:attachment][:default_style] = :product
  end
end
