require 'spec_helper'
describe IndexController, :type => :controller do
  describe 'before filters' do
    let!(:australian_site_version) { create(:site_version, permalink: 'au') }
    let!(:portuguese_site_version) { create(:site_version, permalink: 'pt') }

    describe '#guarantee_site_version_cookie' do
      before(:each) { cookies[:site_verison] = nil }

      context 'given a site version param' do
        it 'sets the site_version cookie according to it' do
          get :show, { site_version: australian_site_version }
          expect(cookies[:site_version]).to eq('au')
        end
      end
    end

    describe '#force_redirection_to_current_site_version' do
      context 'site version cookie differs from param site version' do
        it 'redirects the user to the cookie site version' do
          cookies[:site_version] = 'pt'
          get :show, { site_version: australian_site_version }

          expect(response).to redirect_to('/pt/')
        end
      end

      context 'site version cookie is equal to param site version' do
        it 'does nothing' do
          cookies[:site_version] = 'pt'
          get :show, { site_version: portuguese_site_version }

          expect(response).not_to redirect_to('/pt/')
        end
      end
    end
  end
end