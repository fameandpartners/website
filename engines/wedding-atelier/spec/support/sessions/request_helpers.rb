module Sessions
  module RequestHelpers
    def wedding_sign_in(user = double(Spree::User))
      post '/us/user/spree_user/sign_in', spree_user: { email: user.email, password: user.password }
    end
  end
end

RSpec.configure do |config|
  config.include Sessions::RequestHelpers, type: :request
end
