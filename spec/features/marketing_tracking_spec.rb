require 'spec_helper'

describe 'track users for marketing purposes', type: :feature do
  before(:each) { allow(SecureRandom).to receive(:uuid).and_return('SUPER-SECURE-UUID-FTW') }

  it 'creates cookie with UUID when user visits the website' do
    visit '/'

    expect(page.driver.request.cookies).to include(user_uuid: 'SUPER-SECURE-UUID-FTW')
  end
end
