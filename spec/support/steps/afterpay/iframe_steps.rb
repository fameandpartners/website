module Afterpay
  module Acceptance
    module IframeSteps
      step 'I fill in Afterpay data within its iframe:' do |fields|
        afterpay_fields = fields.to_h
        afterpay_iframe = find('iframe.buy-window')
        within_frame(afterpay_iframe) do
          fill_in 'email', with: afterpay_fields['email']
          click_button 'Continue'

          fill_in 'password', with: afterpay_fields['password']
          click_button 'Sign in'

          fill_in 'name', with: afterpay_fields['name']
          fill_in 'address1', with: afterpay_fields['address1']
          fill_in 'suburb', with: afterpay_fields['suburb']
          fill_in 'state', with: afterpay_fields['state']
          fill_in 'postcode', with: afterpay_fields['postcode']
          click_button 'CONFIRM'

          click_button '✓ OK, GOT IT.'

          unless has_text?('**0000') # Card comes pre-filled
            fill_in 'cardName', with: afterpay_fields['cardName']
            fill_in 'cardNumber', with: afterpay_fields['cardNumber']
            fill_in 'expiryDate', with: afterpay_fields['expiryDate']
          end
          fill_in 'cardCVC', with: afterpay_fields['cardCVC']
          check 'termsAgreed'
          click_button 'CONFIRM'
        end
      end
    end
  end
end

RSpec.configure { |c| c.include Afterpay::Acceptance::IframeSteps, type: :feature }
