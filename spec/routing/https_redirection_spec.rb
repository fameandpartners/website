require 'spec_helper'

describe 'HTTPS redirection', type: :request do
  before(:all) do
    Features.activate(:redirect_to_www_and_https)
    FameAndPartners::Application.reload_routes!
  end

  context 'given any request to fame and partners domain (.com.au and .com)' do
    describe 'redirects to the www subdomain' do
      context '.com domain' do
        it_will :redirect, 'http://fameandpartners.com/anything?something=else', 'https://www.fameandpartners.com/anything?something=else'
        it_will :redirect, 'http://fameandpartners.com', 'https://www.fameandpartners.com'

        it_will :redirect, 'https://fameandpartners.com/anything?something=else', 'https://www.fameandpartners.com/anything?something=else'
        it_will :redirect, 'https://fameandpartners.com', 'https://www.fameandpartners.com'
      end

      context '.com.au domain' do
        it_will :redirect, 'http://fameandpartners.com.au/anything?something=else', 'https://www.fameandpartners.com.au/anything?something=else'
        it_will :redirect, 'http://fameandpartners.com.au', 'https://www.fameandpartners.com.au'

        it_will :redirect, 'https://fameandpartners.com.au/anything?something=else', 'https://www.fameandpartners.com.au/anything?something=else'
        it_will :redirect, 'https://fameandpartners.com.au', 'https://www.fameandpartners.com.au'
      end
    end
  end
end
