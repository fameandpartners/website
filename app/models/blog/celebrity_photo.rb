class Blog::CelebrityPhoto < ActiveRecord::Base
  attr_accessor :publish, :post_slug, :celebrity_slug
  attr_accessible :photo, :post_slug, :celebrity_slug, :publish

  belongs_to :celebrity, class_name: Blog::Celebrity
  belongs_to :post, class_name: Blog::Post
  belongs_to :user, class_name: Spree::User
  has_attached_file :photo

  validates                     :celebrity_id, presence: true
  validates                     :celebrity_slug, presence: true
  validates_attachment_presence :photo

  scope :latest, where("published_at IS NOT NULL").order("published_at desc").limit(4)
  scope :with_posts, includes(:post)

  def publish
    published_at.present?
  end

  def created_at_formatted
    #"Wednesday, May 15th, 2013"
    created_at.strftime("%A, %b #{created_at.day.ordinalize}, %Y")
  end

  def post_slug
    if post.present?
      post.slug
    end
  end

  def celebrity_slug
    if celebrity.present?
      celebrity.slug
    end
  end

  def state
    if published_at?
      'published'
    else
      'not published'
    end
  end
end
