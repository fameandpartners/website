class Blog::Post < ActiveRecord::Base
  module PostTypes
    SIMPLE     = 0
    RED_CARPET = 1
  end

  attr_accessible :body, :title, :category_id, :occured_at,
                  :published_at, :user_id, :slug, :post_type_id,
                  :tag_list, :event_id

  acts_as_taggable

  belongs_to :author
  belongs_to :category
  belongs_to :user, class_name: Spree::User
  belongs_to :event

  has_many   :post_photos
  has_many   :celebrity_photos
  has_many   :celebrities, through: :celebrity_photos

  validates :title, :body, :occured_at,
            :slug, :post_type_id, presence: true
  validates :category_id, presence: true, if: :simple?
  validates :post_type_id, inclusion: [PostTypes::SIMPLE, PostTypes::RED_CARPET]
  validates :slug, uniqueness: true
  validates :event, presence: true, if: :red_carpet?

  scope :published, where('published_at IS NOT NULL').order('published_at desc')
  scope :sidebar, published.limit(20)

  class << self
    def find_by_query(term)
      Blog::Post.joins(
        "LEFT OUTER JOIN blog_authors ON blog_authors.id = blog_posts.author_id"
      ).joins("LEFT OUTER JOIN blog_events ON blog_events.id = blog_posts.event_id").
        where(
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
              LOWER(blog_authors.first_name) LIKE ?
              or LOWER(blog_authors.last_name) LIKE ?
              or LOWER(concat(blog_authors.last_name, ', ', blog_authors.first_name)) LIKE ?
            )
            OR
            (
              LOWER(blog_events.name) LIKE ?
            )
          ), "%#{term}%", "%#{term}%" , "%#{term}%", "%#{term}%", "%#{term}%", "%#{term}%"
        )
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

  def state
    if published_at?
      'published'
    else
      'not published'
    end
  end
end
