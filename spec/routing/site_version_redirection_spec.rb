require 'spec_helper'

describe 'Site Version Redirection', type: :request do

  context 'if request has /us in its path' do
    describe 'redirects path to www.fameandpartners.com domain' do
      it_will :redirect, '/us/something?awesome=true', 'http://us.lvh.me/something?awesome=true'
    end
  end

  context 'if .com.au redirection Feature is turned on' do
    context 'if request has /au in its path' do
      describe 'redirects path to www.fameandpartners.com.au domain' do
        it_will :redirect, '/au/something?awesome=true', 'http://www.fameandpartners.com.au/something?awesome=true'
        it_will :redirect, '/au', 'http://www.fameandpartners.com.au/'
      end
    end
  end
end
