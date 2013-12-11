class Celebrity::Image < ActiveRecord::Base
  belongs_to :celebrity

  has_attached_file :file,
                    url: '/system/celebrities/images/file/:id/:style/:filename',
                    path: '/system/celebrities/images/file/:id/:style/:filename',
                    styles: {
                      thumbnail: ['48x48#', :jpg],
                      medium: ['261x263#', :jpg],
                      large: ['538x538#', :jpg]
                    }

  before_save :update_celebrity_primary_image
  after_destroy :set_another_primary, if: :is_primary?

  attr_accessible :file,
                  :position,
                  :is_primary

  validates_attachment_presence :file

  default_scope order('position ASC')

  private

  def update_celebrity_primary_image
    if celebrity.primary_image.blank?
      self.is_primary = true
    end

    if is_primary?
      celebrity.images.update_all(is_primary: false)
    end
  end

  def set_another_primary
    if is_primary?
      celebrity.images.first.update_column(:is_primary, true)
    end
  end
end
