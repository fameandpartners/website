module Afterpay
  module Acceptance
    module IframeSteps
      step 'I fill in Afterpay data within its iframe:' do |fields|
        # Afterpay makes really hard to use the same user, since they have upper limits on their accounts
        # We're going to generate random users + random Australian phones
        afterpay_fields = fields.to_h
        afterpay_iframe = find('iframe.buy-window')
        random_user     = {
          email: "#{SecureRandom.uuid}@email.com",
          phone: ['614', rand(0..99999999)].join.ljust(11, '0')
        }.stringify_keys

        within_frame(afterpay_iframe) do
          fill_in 'email', with: random_user['email']
          click_button 'Continue'

          fill_in 'mobile', with: random_user['phone']
          click_button 'SEND SMS'

          fill_in 'verificationCode', with: '111111' # Afterpay Bogus SMS confirmation code
          click_button 'VERIFY'

          fill_in 'name', with: afterpay_fields['name']
          fill_in 'address1', with: afterpay_fields['address1']
          fill_in 'suburb', with: afterpay_fields['suburb']
          fill_in 'state', with: afterpay_fields['state']
          fill_in 'postcode', with: afterpay_fields['postcode']
          click_button 'CONFIRM'

          click_button '✓ OK, GOT IT.'

          fill_in 'cardName', with: afterpay_fields['cardName']
          fill_in 'cardNumber', with: afterpay_fields['cardNumber']
          fill_in 'expiryDate', with: afterpay_fields['expiryDate']
          fill_in 'cardCVC', with: afterpay_fields['cardCVC']
          check 'termsAgreed'
          click_button 'CONFIRM'
        end
      end
    end
  end
end

RSpec.configure { |c| c.include Afterpay::Acceptance::IframeSteps, type: :feature }
