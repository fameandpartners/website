module StyleQuiz
  class AutomagicUserRegistrator
    attr_reader :style_profile

    def initialize(style_profile:)
      @style_profile = style_profile
    end

    def create
      return nil if style_profile.user.present?
      if user.save
        style_profile.assign_to_user(user)
        user
      else
        nil
      end
    end

    def user
      @user ||= begin
        first_name, last_name = style_profile.fullname.to_s.split(' ', 2)
        Spree::User.new.tap do |user|
          user.first_name = first_name
          user.last_name  = last_name
          user.email      = style_profile.email
          user.birthday   = style_profile.birthday
          user.skip_welcome_email = true
          user.automagically_registered = true
          user.password = user.password_confirmation = build_password
        end
      end
    end

    def build_password
      SecureRandom.urlsafe_base64(12)
    end
  end
end
