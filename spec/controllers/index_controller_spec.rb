require 'spec_helper'
describe IndexController, :type => :controller do
  describe 'before filters' do
    describe '#force_redirection_to_current_site_version' do
      let!(:australian_site_version) { create(:site_version, permalink: 'au') }
      let!(:portuguese_site_version) { create(:site_version, permalink: 'pt') }

      context 'user cookie site version is different from the requested' do
        before(:each) { controller.instance_variable_set(:@current_site_version, portuguese_site_version) }

        it 'redirects the user to the cookie site version' do
          cookies[:site_version] = 'pt'
          get :show, { site_version: australian_site_version }

          expect(response).to redirect_to('/pt/')
        end
      end

      context 'user cookie site version is them same from the requested' do
        it 'does nothing' do
          cookies[:site_version] = 'pt'
          get :show, { site_version: portuguese_site_version }

          expect(response).not_to redirect_to('/pt/')
        end
      end
    end
  end
end