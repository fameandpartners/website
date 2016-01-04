module Revolution
  class Translation
    class Banner < ActiveRecord::Base
      belongs_to :translation, inverse_of: :banners
      validates :banner_order, :alt_text, presence: true
      validates_uniqueness_of :banner_order, scope: :translation_id

      attr_accessible :alt_text, :translation_id, :banner, :size, :banner_order,
                      :banner_file_name, :banner_content_type, :banner_file_size
      has_attached_file :banner
      validates_attachment_content_type :banner, content_type: /\Aimage\/.*\Z/
      validates_attachment_presence :banner
    end
  end
end
