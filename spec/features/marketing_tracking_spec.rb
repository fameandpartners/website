require 'spec_helper'

describe 'track users for marketing purposes', type: :feature do
  before(:each) { allow(SecureRandom).to receive(:uuid).and_return('SUPER-SECURE-UUID-FTW') }

  it 'creates cookie with UUID when user visits the website' do
    visit '/'

    cookie = get_me_the_cookie('user_uuid')
    expect(cookie[:value]).to eq('SUPER-SECURE-UUID-FTW')
  end
end
