class PostState < ActiveRecord::Base
  attr_accessible :title

  has_many :posts
  has_many :celebrity_photos
  has_many :fashion_news
  has_many :prom_tips
  has_many :style_tips
  has_many :red_carpet_events
end
