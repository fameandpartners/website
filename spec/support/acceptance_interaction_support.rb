module AcceptanceInteractionSupport
  def click_layered_element(type, locator, options = {})
    if Capybara.current_driver == :poltergeist
      find(type, locator, options).trigger('click')
    else
      find(type, locator, options).click
      sleep 0.5 # Wait animation to fade away. This is horrible, I know...
    end
  end
end

RSpec.configure do |config|
  config.include AcceptanceInteractionSupport, type: :feature

  config.before(:each, type: :feature) do
    Features.deactivate(:test_analytics)
  end
end
