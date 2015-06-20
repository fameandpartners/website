Spree::User.class_eval do
  has_one :style_profile, class_name: '::StyleQuiz::UserProfile', foreign_key: 'user_id'
end
