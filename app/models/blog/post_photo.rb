class Blog::PostPhoto < ActiveRecord::Base

  attr_writer     :primary
  attr_accessible :photo, :primary

  belongs_to :post, class_name: Blog::Post, counter_cache: true
  belongs_to :user, class_name: Spree::User

  has_attached_file :photo

  validates_attachment_presence :photo
  validates :user_id, :post, presence: true

  def primary
    self.persisted? && post.primary_photo_id == self.id
  end

  def primary_text
    primary ? 'yes' : 'no'
  end
end
