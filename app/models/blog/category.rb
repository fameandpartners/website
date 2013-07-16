class Blog::Category < ActiveRecord::Base
  attr_accessible :name, :slug, :user_id

  belongs_to :user, class_name: Spree::User
  has_many :posts, class_name: Blog::Post, dependent: :destroy

  validates :name, :slug, :user_id, presence: true

  def latest_post
    posts.published.where(post_type_id: Blog::Post::PostTypes::SIMPLE).order('published_at desc').first
  end
end
