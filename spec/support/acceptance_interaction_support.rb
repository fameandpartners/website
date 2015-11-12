module AcceptanceInteractionSupport
  def click_layered_element(type, locator, options = {})
    find(type, locator, options).trigger('click')
  end
end

RSpec.configure do |config|
  config.include AcceptanceInteractionSupport, type: :feature
end
