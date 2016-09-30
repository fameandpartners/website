module Afterpay
  module Acceptance
    module ApiSteps
      step 'Afterpay API is not available' do
        allow_any_instance_of(::Afterpay::SDK::Merchant::API).to receive(:create_order).and_raise('Afterpay is not available')
      end
    end
  end
end

RSpec.configure { |c| c.include Afterpay::Acceptance::ApiSteps, type: :feature }
