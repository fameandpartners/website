require 'spec_helper'

describe 'Not found requests', type: :request do

  describe 'with *.php' do
    it 'routes to application#non_matching_request' do
      get '/abc.php'

      expect(response).to render_template(nil)
      expect(response).to have_http_status(406)
    end
  end

  describe 'with any non-existent page' do
    it 'rotes to application#non_matching_request' do
      get '/abc'

      expect(response.body).to match("this page doesn't exist")
      expect(response.body).to match('MY ACCOUNT')
      expect(response.body).to match('Fame &amp; Partners. All rights reserved.')
      expect(response).to have_http_status(404)
    end
  end

  describe 'with an undefined page' do
    it 'rotes to application#non_matching_request' do
      get '/undefined'

      expect(response.body).to match('Not Found')
      expect(response).to have_http_status(404)
    end
  end

end
