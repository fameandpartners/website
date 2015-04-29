require 'spec_helper'
describe ApplicationController, :type => :controller do
  describe '#is_user_came_from_current_app' do
    it 'returns true if referrer has the same host' do
      request.env["HTTP_REFERER"] = "http://test.host/somewhere"
      expect(controller.send(:is_user_came_from_current_app)).to eq(true)
    end

    it 'returns false for empty referrer' do
      expect(controller.send(:is_user_came_from_current_app)).to eq(false)
    end

    it 'returns false for external referrer' do
      request.env["HTTP_REFERER"] = "http://external.host/somewhere"
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
=begin
  def is_user_came_from_current_app
    return false if request.referrer.blank?
    URI.parse(request.referrer).host == request.host
  rescue Exception => e
    # built-in ruby uri known for parse/generate issues.
    false
  end

  def set_after_sign_in_location(location, options = {})
    return if location && location.match(/\b(login|logout|fb_auth|session|sign_in|sign_out)\b/)
    session[:user_return_to] = location
    session[:spree_user_return_to] = location
  end
=end
