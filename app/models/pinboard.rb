class Pinboard < ActiveRecord::Base
  belongs_to :user
  attr_accessible :description, :event_date, :name, :purpose
end
