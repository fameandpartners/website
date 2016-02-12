require 'spec_helper'

describe OrderReturnRequestMailer, type: :mailer do
  let(:order_return_request) { instance_double(OrderReturnRequest, name: 'blah', phone_number: '1234', shipping_address: '', number: 'R1234', completed_at: 1.days.ago, return_request_items: []) }
  let(:user)                 { instance_double(Spree::User, email: 'blah@vtha.com') }

  subject(:email)            { OrderReturnRequestMailer.email(order_return_request, user).deliver }

  it { expect(email.to).to contain_exactly('team@fameandpartners.com') }
  it { expect(email.reply_to).to contain_exactly('blah@vtha.com') }
  it { expect(email.subject).to eq('[Order Return Request] R1234') }

  it 'has some data' do
    expect(email).to have_content('R1234')
  end
end
