class Blog::Post < ActiveRecord::Base
  module PostTypes
    SIMPLE     = 0
    RED_CARPET = 1
  end

  PRIMARY_TYPES = %w{photo video}

  attr_accessible :body, :title, :description, :category_id, :occured_at,
                  :published_at, :user_id, :slug, :post_type_id,
                  :video_url, :primary_type,
                  :tag_list

  acts_as_taggable

  belongs_to :author
  belongs_to :category
  belongs_to :user, class_name: Spree::User

  has_many   :post_photos
  has_many   :celebrity_photos
  has_many   :celebrities, through: :celebrity_photos

  validates :title, :body, :occured_at,
            :slug, :post_type_id, presence: true
  validates :category_id, presence: true, if: :simple?
  validates :post_type_id, inclusion: [PostTypes::SIMPLE, PostTypes::RED_CARPET]
  validates :slug, uniqueness: true
  validates :primary_type, inclusion: PRIMARY_TYPES, allow_blank: true

  scope :red_carpet, where(post_type_id: PostTypes::RED_CARPET)
  scope :published, where('published_at IS NOT NULL').order('published_at desc')
  scope :sidebar, red_carpet.published.limit(20)
  scope :simple_posts, order('created_at desc').where(post_type_id: PostTypes::SIMPLE)
  scope :red_carpet_posts, order('occured_at desc').where(post_type_id: PostTypes::RED_CARPET)
  scope :featured, where(post_type_id: PostTypes::SIMPLE).where('featured_at is not null').order('featured_at desc').limit(5)

  after_save do
    celebrities.each(&:save) if published_at_changed?
  end

  class << self
    def find_by_query(term)
      Blog::Post.joins(
        "LEFT OUTER JOIN spree_users ON spree_users.id = blog_posts.user_id"
      ).joins("LEFT OUTER JOIN blog_celebrity_photos ON blog_celebrity_photos.post_id = blog_posts.id").joins(
        'LEFT OUTER JOIN blog_celebrities ON blog_celebrities.id = blog_celebrity_photos.celebrity_id'
      ).joins(
        "LEFT OUTER JOIN taggings ON (taggings.taggable_id = blog_posts.id AND taggings.taggable_type = 'Blog::Post')"
      ).joins(
        'LEFT OUTER JOIN tags ON taggings.tag_id = tags.id'
      ).where(
        %Q(
          (
            LOWER(blog_posts.title) LIKE ?
          )
          OR
          (
            LOWER(blog_posts.body) LIKE ?
          )
          OR
          (
            LOWER(spree_users.first_name) LIKE ?
            or LOWER(spree_users.last_name) LIKE ?
            or LOWER(concat(spree_users.last_name, ', ', spree_users.first_name)) LIKE ?
            or LOWER(concat(spree_users.first_name, ', ', spree_users.last_name)) LIKE ?
          )
          OR
          (
            LOWER(blog_celebrities.first_name) LIKE ?
            or LOWER(blog_celebrities.last_name) LIKE ?
            or LOWER(concat(blog_celebrities.last_name, ', ', blog_celebrities.first_name)) LIKE ?
            or LOWER(concat(blog_celebrities.first_name, ', ', blog_celebrities.last_name)) LIKE ?
          )
          OR
          (
            LOWER(tags.name) LIKE ?
          )
        ), "%#{term}%", "%#{term}%" , "%#{term}%", "%#{term}%", "%#{term}%",
            "%#{term}%", "%#{term}%", "%#{term}%", "%#{term}%", "%#{term}%",
            "%#{term}%"
      ).group('blog_posts.id')
    end
  end

  def primary_photo
    @primary_photo ||= if primary_photo_id.present?
      post_photos.where(id: primary_photo_id).first
    end
  end

  def red_carpet?
    post_type_id == PostTypes::RED_CARPET
  end

  def simple?
    post_type_id == PostTypes::SIMPLE
  end

  def post_type_text
    if red_carpet?
      "Red Carpet"
    elsif simple?
      "Simple"
    end
  end

  def occured_at_formatted
    #"Wednesday, May 15th, 2013"
    occured_at.strftime("%A, %b #{occured_at.day.ordinalize}, %Y")
  end

  def created_at_formatted
    #"Wednesday, May 15th, 2013"
    created_at.strftime("%A, %b #{created_at.day.ordinalize}, %Y")
  end

  def published?
    published_at.present?
  end

  def featured?
    featured_at.present?
  end

  def featured
    if featured_at?
      'featured'
    else
      'not featured'
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
