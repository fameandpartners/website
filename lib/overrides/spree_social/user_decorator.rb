Spree::User.class_eval do
  def apply_omniauth_with_additional_attributes(omniauth)
    if omniauth['provider'] == "facebook"
      self.email = omniauth['info']['email'] if email.blank?
      self.first_name = omniauth['info']['first_name'] if first_name.blank?
      self.last_name = omniauth['info']['last_name'] if last_name.blank?
    end
    user_authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end
end
