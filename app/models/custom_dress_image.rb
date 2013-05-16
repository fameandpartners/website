class CustomDressImage < ActiveRecord::Base
  CONTENT_TYPES =%w( image/png image/jpg image/jpeg image/gif image/tiff )

  attr_accessible :file

  has_attached_file :file,
                    :styles => {
                      :thumbnail => ['90x110#', :jpg]
                    }

  belongs_to :custom_dress

  validates_attachment_presence :file
  validates_attachment_size :file,
                            :in => 0..600.kilobytes
  validates_attachment_content_type :file,
                                    :content_type => CONTENT_TYPES

  def thumbnail_url
    file.url(:thumbnail)
  end

  def serialized_errors
    if errors.present?
      errors.full_messages
    else
      nil
    end
  end

  def as_json(options={})
    super(
      :root => false,
      :only => [:id, :file_file_name],
      :methods => [:thumbnail_url, :serialized_errors]
    )
  end
end
