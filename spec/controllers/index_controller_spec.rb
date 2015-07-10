require 'spec_helper'
describe IndexController, :type => :controller do
  describe 'before filters' do
    describe '#force_redirection_to_current_site_version' do
      let!(:australian_site_version) { create(:site_version, permalink: 'au') }
      let!(:portuguese_site_version) { create(:site_version, permalink: 'pt') }

      context 'site version cookie is not set' do
        before(:each) { allow(controller).to receive(:current_site_version).and_return(portuguese_site_version) }

        context 'current site version differs from param site version' do
          it 'redirects the user his/her current site version' do
            get :show, { site_version: australian_site_version }
            expect(response).to redirect_to('/pt/')
          end
        end

        context 'current site version is equal to param site version' do
          it 'does nothing' do
            get :show, { site_version: portuguese_site_version }
            expect(response).to be_success
          end
        end
      end

      context 'site version cookie is set' do
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
end