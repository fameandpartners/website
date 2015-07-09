class StyleQuiz::OldProfilesRemoval
  def perform
    StyleQuiz::UserProfile.where(user_id: nil).where('created_at > ?', 1.month.ago).destroy_all
  rescue Exception => e
  end
end
