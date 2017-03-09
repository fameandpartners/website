module FeaturesHelper
  def react_flash_errors
    JSON.parse(page.find(:css, '.error-notification')['data-react-props'])["errors"]
  end
end

RSpec.configure do |config|
  config.include FeaturesHelper, type: :feature
end
