class Blog::Celebrity < ActiveRecord::Base
  attr_writer :featured
  attr_accessible :first_name, :last_name, :user_id, :featured, :slug

  validates  :first_name, :last_name, :user_id, :slug, presence: :true
  validates  :slug, uniqueness: true
  belongs_to :user, class_name: Spree::User
  has_many   :celebrity_photos, dependent: :destroy, class_name: Blog::CelebrityPhoto

  scope :featured, where("featured_at IS NOT NULL").limit(4).order("featured_at desc")

  def main_photo
    celebrity_photos.first
  end

  def posts
    Blog::Post.joins(:celebrity_photos).where('blog_celebrity_photos.celebrity_id = ?', self.id)
  end

  def fullname
    [first_name, last_name].join(' ')
  end

  def featured_state
    if featured_at.present?
      'yes'
    else
      'no'
    end
  end

  def featured
    featured_at.present?
  end
end
