module StyleQuiz; end

class StyleQuiz::UserStyleProfileLoader
  attr_reader :token, :user

  def initialize(token:, user:)
    @token = token
    @user = user
  end

  def load
    profile = load_profile
    assign_to_user(profile)
    profile
  end

  private

    def load_profile
      if token.present?
        profile = StyleQuiz::UserProfile.find_by_token(token)
        return profile if profile.present?
      end
      if user.present?
        return user.style_profiles.last
      end
    end

    def assign_to_user(profile)
      return if user.blank? || profile.blank? || profile.user_id == user.id
      profile.update_column(:user_id, user.id)
    end
end
