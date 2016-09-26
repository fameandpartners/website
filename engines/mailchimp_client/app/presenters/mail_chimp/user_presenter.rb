module MailChimp
  class UserPresenter

    attr_accessor :user

    def initialize(user)
      self.user = user
    end

    def to_h
      {
        id:            user.id.to_s,
        email_address: user.email,
        first_name:    user.first_name,
        last_name:     user.last_name,
        opt_in_status: false
      }
    end
  end
end
