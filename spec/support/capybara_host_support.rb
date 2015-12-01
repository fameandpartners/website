module CapybaraHostSupport
  def with_capybara_host(host, &block)
    capybara_default_host = Capybara.default_host

    default_url_options[:host] = host
    Capybara.app_host          = "http://#{host}"
    yield

    Capybara.default_host = capybara_default_host
  end
end

RSpec.configure do |config|
  config.include CapybaraHostSupport, type: :feature
end
