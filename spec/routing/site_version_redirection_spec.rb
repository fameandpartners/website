require 'spec_helper'

describe 'Site Version Redirection', type: :request do

  context 'if request has /us in its path' do
    describe 'redirects path to www.fameandpartners.com domain' do
      it_will :redirect, '/us/something?awesome=true', 'http://us.lvh.me/something?awesome=true'
    end
  end

  context 'if .com.au redirection Feature is turned on' do
    before(:each) do
      Features.activate(:redirect_to_com_au_domain)
      FameAndPartners::Application.reload_routes!
    end

    after(:each) do
      Features.deactivate(:redirect_to_com_au_domain)
      FameAndPartners::Application.reload_routes!
    end

    context 'if request has /au in its path' do
      describe 'redirects path to www.fameandpartners.com.au domain' do
        it_will :redirect, '/au/something?awesome=true', 'http://us.lvh.me/something?awesome=true'
        it_will :redirect, '/au', 'http://us.lvh.me/'
      end
    end
  end
end
