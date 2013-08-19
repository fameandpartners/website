class Blog::PromoBanner < ActiveRecord::Base
  attr_accessible :title, :url, :position, :published, :photo, :description

  belongs_to :user, class_name: Spree::User
  has_attached_file :photo, styles: { preview: "1078x434#"}

  validates :user_id, presence: true
  validates_attachment_presence :photo

  scope :published, where(published: true)
  before_post_process :randomize_file_name
  before_create

  def state
    if published?
      'published'
    else
      'not published'
    end
  end

  def randomize_file_name
    if photo.present?
      extension = File.extname(photo_file_name).downcase
      self.photo.instance_write(:file_name, "#{SecureRandom.hex(16)}#{extension}")
    end
  end
end
