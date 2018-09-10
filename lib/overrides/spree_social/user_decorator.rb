Spree::User.class_eval do
  require 'open-uri'

  def apply_omniauth_with_additional_attributes(omniauth)
    if omniauth['provider'] == "facebook"
      token = omniauth.try(:credentials).try(:token)
      raise 'No authentication token' unless token

      graph = Koala::Facebook::API.new(token)
      facebook_user = graph.get_object('me?fields=email,first_name,last_name', {}, api_version: "v3.1")

      self.email      = facebook_user['email'] if email.blank?
      self.first_name = facebook_user['first_name'] if first_name.blank?
      self.last_name  = facebook_user['last_name'] if last_name.blank?

      if Rails.env.development?
        logger.warn "Facebook: not using avatar"
      else
        avatar_url = graph.get_picture_data('me', width: 1024, height: 1024).try(:[], 'data').try(:[], 'url')
        self.avatar = open(avatar_url)
      end
    end
  rescue StandardError => e
    NewRelic::Agent.notice_error(e)
  ensure
    apply_omniauth(omniauth)
  end
end
