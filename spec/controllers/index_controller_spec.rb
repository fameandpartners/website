require 'spec_helper'
describe IndexController, :type => :controller do
  describe 'before filters' do
    describe '#force_redirection_to_current_site_version' do
      let!(:australian_site_version) { create(:site_version, permalink: 'au') }
      let!(:portuguese_site_version) { create(:site_version, permalink: 'pt') }

      context 'user current_site_version is different from requested' do
        before(:each) { controller.instance_variable_set(:@current_site_version, portuguese_site_version) }

        it 'redirects the user to its current version' do
          get :show, { site_version: australian_site_version }
          expect(response).to redirect_to('/pt/')
        end
      end

      context 'user current_site_version is the same from requested' do
        before(:each) { controller.instance_variable_set(:@current_site_version, portuguese_site_version) }

        it 'redirects the user to its current version' do
          get :show, { site_version: portuguese_site_version }
          expect(response).to have_http_status(:success)
          expect(response).not_to redirect_to('/pt/')
        end
      end
    end
  end
end