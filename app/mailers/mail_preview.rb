if Rails.env.development? || Rails.env.test?
  class MailPreview < MailView

    # Stub-like
    def marketing_email
      user = Struct.new(:email, :name).new('name@example.com', 'Jill Smith')
      mail = Spree::CompetitionsMailer.marketing_email(user.email)
    end
  end
end