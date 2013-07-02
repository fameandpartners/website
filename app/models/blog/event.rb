class Blog::Event < ActiveRecord::Base
  attr_accessible :name, :slug

  has_many :posts, class_name: Blog::Post
  belongs_to :user, class_name: Spree::User

  validates :name, :slug, presence: true
  validates :slug, uniqueness: true
end
