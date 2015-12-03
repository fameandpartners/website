# Based on https://gist.github.com/turadg/5399790

# Support for Rspec / Capybara subdomain integration testing
# Make sure this file is required by spec_helper.rb
# (e.g. save as spec/support/subdomains.rb)

module CapybaraHostSupport
  module Controllers
    def switch_to_subdomain(subdomain)
      hostname      = subdomain ? "#{subdomain}.lvh.me" : 'lvh.me'
      @request.host = hostname
    end
  end

  module Features
    def switch_to_subdomain(subdomain)
      hostname          = subdomain ? "#{subdomain}.lvh.me" : 'lvh.me'
      Capybara.app_host = "http://#{hostname}"
    end
  end

  module Requests
    def switch_to_subdomain(subdomain)
      hostname = subdomain ? "#{subdomain}.lvh.me" : 'lvh.me'
      host! hostname
    end
  end
end

RSpec.configure do |config|
  config.include CapybaraHostSupport::Controllers, type: :controller
  config.include CapybaraHostSupport::Features, type: :feature
  config.include CapybaraHostSupport::Requests, type: :request

  config.before(:each, type: :request) do
    switch_to_subdomain 'us'
  end

  config.before(:each, type: :feature) do
    switch_to_subdomain 'us'
  end

  config.before(:each, type: :controller) do
    switch_to_subdomain 'us'
  end
end
