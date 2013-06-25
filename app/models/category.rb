class Category < ActiveRecord::Base
  attr_accessible :title

  has_many :posts
  has_many :photo_posts

  validates :title, presence: true

end
