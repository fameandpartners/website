require 'gibbon'

module MailChimp
  class GibbonInstance

    def self.call
      Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])
    end
  end
end
