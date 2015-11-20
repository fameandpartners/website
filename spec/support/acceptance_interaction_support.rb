module AcceptanceInteractionSupport
  def click_layered_element(type, locator, options = {})
    find(type, locator, options).trigger('click')
  end
end

RSpec.configure do |config|
  config.include AcceptanceInteractionSupport, type: :feature

  config.before(:each, type: :feature) do
    Features.deactivate(:test_analytics)
  end
end
