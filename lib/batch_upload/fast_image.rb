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

    self.attachment_definitions[:attachment]                 = Spree::Image.attachment_definitions[:attachment]
  end
end
