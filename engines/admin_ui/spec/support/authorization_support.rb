module AdminUi::AuthorizationSupport
  module ControllerHelpers
    def stub_admin_authorization!
      allow_any_instance_of(AdminUi::ApplicationController).to receive(:authorize_admin).and_return(true)
    end
  end
end

RSpec.configure do |config|
  config.include AdminUi::AuthorizationSupport::ControllerHelpers, type: :controller
end
