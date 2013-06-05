class Celebrity < ActiveRecord::Base
  attr_accessible :name

  has_many :celebrity_photos
end
