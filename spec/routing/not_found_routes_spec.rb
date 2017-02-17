require 'spec_helper'

describe 'Not found requests', type: :request do

  describe 'routes to application#non_matching_request' do
    before(:each) do
      allow(Rails.application.config).to receive(:consider_all_requests_local).and_return(false)
    end

    it 'with *.php' do
      get '/abc.php'

      expect(response).to render_template(nil)
      expect(response).to have_http_status(406)
    end

    it 'with any non-existent page' do
      get '/abc'

      expect(response.body).to match("this page doesn't exist")
      expect(response.body).to match('MY ACCOUNT')
      expect(response.body).to match('Fame &amp; Partners. All rights reserved.')
      expect(response).to have_http_status(404)
    end

    it 'with an undefined page' do
      get '/undefined'

      expect(response.body).to match('Not Found')
      expect(response).to have_http_status(404)
    end
  end

end
