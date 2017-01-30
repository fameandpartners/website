module Sessions
  module ControllerHelpers
    def wedding_sign_in(user = double(Spree::User))
      if user.nil?
        allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, { :scope => :user })
        allow(controller).to receive(:spree_current_user).and_return(nil)
      else
        allow(request.env['warden']).to receive(:authenticate!).and_return(user)
        allow(controller).to receive(:spree_current_user).and_return(user)
      end
    end
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include Sessions::ControllerHelpers, type: :controller
end
