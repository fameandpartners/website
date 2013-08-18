class Blog::Celebrity < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :user_id, :featured, :slug

  validates  :first_name, :last_name, :user_id, :slug, presence: :true
  validates  :slug, uniqueness: true
  belongs_to :user, class_name: Spree::User
  has_many   :celebrity_photos, dependent: :destroy, class_name: Blog::CelebrityPhoto
  belongs_to :primary_photo, class_name: Blog::CelebrityPhoto, foreign_key: :primary_photo_id

  scope :featured, where("featured_at IS NOT NULL").limit(4).order("featured_at desc")
  scope :with_primary_photo, where('primary_photo_id IS NOT NULL')

  before_save :assign_primary_photo

  def posts
    Blog::Post.joins(:celebrity_photos).where('blog_celebrity_photos.celebrity_id = ?', self.id)
  end

  def fullname
    [first_name, last_name].join(' ')
  end

  def featured?
    featured_at.present?
  end

  def featured_state
    if featured_at.present?
      'yes'
    else
      'no'
    end
  end

  def assign_primary_photo
    if primary_photo.blank? || primary_photo.post.blank? || !primary_photo.post.published?
      self.primary_photo_id = celebrity_photos.with_posts.published.order('blog_celebrity_photos.created_at DESC').first.try(:id)
    end
  end
end
