class StyleQuiz::UserProfile < ActiveRecord::Base
  belongs_to :user, class_name: 'Spree::User', foreign_key: 'user_id'

  serialize :answers, Hash
  serialize :tags,    Hash
end
