Spree::User.class_eval do
  require 'open-uri'
  require 'net/http'

  def apply_omniauth_with_additional_attributes(omniauth)
    if omniauth['provider'] == "facebook"

      self.email      = omniauth['info']['email'] if email.blank?
      self.first_name = omniauth['info']['first_name'] if first_name.blank?
      self.last_name  = omniauth['info']['last_name'] if last_name.blank?

      response    = Net::HTTP.get_response(
        URI.parse("http://graph.facebook.com/#{omniauth['uid']}/picture?width=1024&height=1024")
      )
      self.avatar = open(response.header['location'])
    end
  rescue StandardError => e
    NewRelic::Agent.notice_error(e)
  ensure
    apply_omniauth(omniauth)
  end
end
