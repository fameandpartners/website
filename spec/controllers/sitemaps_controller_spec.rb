require 'spec_helper'

describe SitemapsController, :type => :controller do
  describe 'GET /sitemap_index.xml' do
    subject { get :index, site_version: 'au', format: 'xml' }

    it 'redirects the user to the sitemap index URL' do
      expect(subject).to redirect_to('http://images.fameandpartners.com/sitemap/sitemap.xml.gz')
      expect(subject).to have_http_status(:moved_permanently)
    end
  end

  describe 'GET /sitemap.xml' do
    context 'request has a site version' do
      subject { get :show, site_version: 'au', format: 'xml' }

      it 'redirects to the requested sitemap version' do
        expect(subject).to redirect_to('http://images.fameandpartners.com/sitemap/au.xml.gz')
      expect(subject).to have_http_status(:moved_permanently)
      end
    end

    context 'request does not have a site version' do
      subject { get :show, format: 'xml' }

      it 'redirects to the default sitemap version' do
        expect(subject).to redirect_to('http://images.fameandpartners.com/sitemap/us.xml.gz')
        expect(subject).to have_http_status(:moved_permanently)
      end
    end
  end
end