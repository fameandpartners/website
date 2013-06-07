class Quiz < ActiveRecord::Base
  attr_accessible :name

  has_many :questions,
           :dependent => :destroy,
           :order => 'position ASC'
end
