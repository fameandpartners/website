require 'spec_helper'

describe Concerns::SiteVersion, type: :controller do
  controller do
    include Concerns::SiteVersion

    def index
      render text: 'ok'
    end

    def create
      render text: 'create'
    end
  end

  describe 'before filters' do
    describe '#check_site_version' do
      let(:australian_site_verison) { create(:site_version, permalink: 'au') }
      let(:brazilian_site_version)  { create(:site_version, permalink: 'br') }

      context 'site version param is different than current site version code' do
        before(:each) { controller.instance_variable_set(:@current_site_version, brazilian_site_version) }

        it 'sets the requested version as the current site version' do
          get :index, { site_version: australian_site_verison }

          current_site_version = controller.instance_variable_get(:@current_site_version)
          expect(current_site_version).to eq(australian_site_verison)
        end

        describe 'does not change the current site version' do
          after(:each) do
            current_site_version = controller.instance_variable_get(:@current_site_version)
            expect(current_site_version).to eq(brazilian_site_version)
          end

          it 'when it is a non GET request' do
            post :create, { site_version: australian_site_verison }
          end

          it 'when it is a AJAX request' do
            xhr :post, :create, { site_version: australian_site_verison }
          end

          it 'when it is a request to /checkout path' do
            allow(request).to receive(:path).and_return('/checkout')
            get :index, { site_version: australian_site_verison }
          end
        end
      end
    end
  end

  describe '#site_versions_enabled?' do
    before(:each) { SiteVersion.delete_all }

    it 'tells if there is more than one site version available' do
      create(:site_version)
      expect(controller.site_versions_enabled?).to be_falsy

      create(:site_version)
      expect(controller.site_versions_enabled?).to be_truthy
    end
  end

  describe '#current_site_version' do
    pending 'This method needs refactoring'
  end

  describe '#site_version_param' do
    context 'params site version is set' do
      before(:each) { controller.params[:site_version] = 'pt' }

      it 'returns the params site version' do
        expect(controller.site_version_param).to eq('pt')
      end
    end

    context 'params site version is not set' do
      let(:australian_site_verison) { create(:site_version, permalink: 'au', default: true) }

      before(:each) { expect(SiteVersion).to receive(:default).and_return(australian_site_verison) }

      it 'returns the default site version code' do
        expect(controller.site_version_param).to eq('au')
      end
    end
  end

  describe '#set_site_version_cookie' do
    it 'sets a permanent site version cookie' do
      expect(cookies[:site_version]).to be_nil

      controller.set_site_version_cookie('au')
      expect(cookies[:site_version]).to eq('au')
    end
  end
end