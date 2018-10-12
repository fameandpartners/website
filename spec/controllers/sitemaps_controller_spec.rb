require 'spec_helper'

describe SitemapsController, type: :controller do
  let(:asset_host) { ENV['RAILS_ASSET_HOST'] }

  before do
    create :site_version, :us, :default
    create :site_version, :au
  end

  describe 'GET /sitemap.xml' do
    context 'request has a site version' do
      subject { get :index, format: 'xml' }

      before(:each) { request.env['site_version_code'] = 'au' }

      it 'redirects to the requested sitemap version' do
        expect(subject).to redirect_to("#{asset_host}/sitemap/au.xml.gz")
        expect(subject).to have_http_status(:moved_permanently)
      end
    end

    context 'request does not have a site version' do
      subject { get :index, format: 'xml' }

      it 'redirects to the default sitemap version' do
        expect(subject).to redirect_to("#{asset_host}/sitemap/us.xml.gz")
        expect(subject).to have_http_status(:moved_permanently)
      end
    end
  end
end
