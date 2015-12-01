require 'spec_helper'

describe ApplicationController, type: :controller do
  describe '#is_user_came_from_current_app' do
    it 'returns true if referrer has the same host' do
      request.env['HTTP_REFERER'] = 'http://us.lvh.me/somewhere'
      expect(controller.send(:is_user_came_from_current_app)).to eq(true)
    end

    it 'returns false for empty referrer' do
      expect(controller.send(:is_user_came_from_current_app)).to eq(false)
    end

    it 'returns false for external referrer' do
      request.env['HTTP_REFERER'] = 'http://external.host/somewhere'
      expect(controller.send(:is_user_came_from_current_app)).to eq(false)
    end
  end

  describe '#set_after_sign_in_location' do
    it 'ignores login pages' do
      location = double('location', match: 'location')
      controller.send(:set_after_sign_in_location, location)
      expect(controller.session[:user_return_to]).to eq(nil)
    end

    it 'sets session variables' do
      location = double('location', match: nil)
      controller.send(:set_after_sign_in_location, location)

      expect(controller.session[:user_return_to]).to eq(location)
      expect(controller.session[:spree_user_return_to]).to eq(location)
    end
  end
end
