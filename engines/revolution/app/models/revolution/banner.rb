module Revolution
  class Banner < ActiveRecord::Base

    PAGE_SIZE            = {full: 'full', small: 'small'}
    FULL_FILE_DIMENSION  = {width: 1122, height: 155}
    SMALL_FILE_DIMENSION = {width: 561, height: 78}

    belongs_to :translation, inverse_of: :banners
    validates :banner_order, :alt_text, presence: true
    # validates_uniqueness_of :banner_order, scope: [:translation_id, :size]

    attr_accessible :alt_text, :translation_id, :banner, :size, :banner_order,
                    :banner_file_name, :banner_content_type, :banner_file_size
    has_attached_file :banner
    validates_attachment_content_type :banner, content_type: /\Aimage\/.*\Z/
    validates_attachment_presence :banner
    validates_attachment_size :banner, in: 0..201.kilobytes

    before_create :set_dimensions, if: :uploaded_file?

    def self.banner_pos(banner_order, size)
      where('banner_order >= ? and size = ?', banner_order, size).order(:banner_order)
    end

    def self.banner_present(size)
      where(size: size).present?
    end

    def banner_url
      banner.url
    end

    def banner_before_save
      banner.queued_for_write[:original].present?
    end

    def uploaded_file
      banner.queued_for_write[:original]
    end

    def uploaded_file?
      uploaded_file.present?
    end

    private

    def set_dimensions
      dimensions = Paperclip::Geometry.from_file(uploaded_file.path)
      self.banner_width = dimensions.width
      self.banner_height = dimensions.height
    end

  end
end
