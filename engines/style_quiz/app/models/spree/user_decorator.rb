Spree::User.class_eval do
  has_many :style_profiles, class_name: 'StyleQuiz::UserProfile', foreign_key: 'user_id'
end
