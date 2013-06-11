class PostState < ActiveRecord::Base
  attr_accessible :title

  has_many :posts
  has_many :celebrity_photos
  has_many :red_carpet_events
end
