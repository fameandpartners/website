require 'gibbon'

module MailChimp

  class Client

    def self.request
      Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])
    end
  end
end
