require "spec_helper"

describe OrderReturnRequestMailer, :type => :mailer do

  let(:order_return_request)  { double(OrderReturnRequest, :name => 'blah', :phone_number => '1234', :shipping_address => '', :number => '1234', :completed_at => 1.days.ago, :return_request_items => [])}
  let(:user)                  { double(Spree::User, :email => 'blah@vtha.com') }

  let(:email)                 { OrderReturnRequestMailer.email(order_return_request, user).deliver }

  it 'delivers' do
    ActionMailer::Base.deliveries.empty?
  end

  it 'sends to desk' do
    expect(email.to).to include 'team@fameandpartners.com'
  end

  it 'has some data' do
    expect(email.to_s).to include order_return_request.number
  end

end
