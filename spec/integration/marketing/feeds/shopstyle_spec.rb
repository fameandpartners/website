require 'rails_helper'

module Marketing
  module Feeds
    RSpec.describe 'Shopstyle Feed', type: :request do
      describe 'GET /au/feeds/products/shopstyle.xml' do

        # `dev-fameandpartners` bucket name is declared on `.env.test` file
        let(:s3_url) { 'https://s3.amazonaws.com/dev-fameandpartners/feeds/au/products/shopstyle.xml' }

        it 'redirects (301) to shopstyle S3 URL' do
          get '/au/feeds/products/shopstyle.xml'

          expect(response).to redirect_to(s3_url)
          expect(response).to have_http_status(:moved_permanently)
        end
      end
    end
  end
end
