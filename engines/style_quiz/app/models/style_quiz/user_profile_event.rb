class StyleQuiz::UserProfileEvent < ActiveRecord::Base
  belongs_to :user_profile, class_name: 'StyleQuiz::UserProfile', foreign_key: 'user_profile_id'

  attr_accessible :name, :event_type, :date

  validates :name, presence: true
  validates :date, presence: true
end
