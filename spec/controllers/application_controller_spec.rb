require 'spec_helper'

describe ApplicationController, :type => :controller do
  controller do
    def index
      render :text => 'ok'
    end
  end

  describe 'before filters' do
    describe '#check_site_version' do
      let!(:australian_site_version) { create(:site_version, permalink: 'au') }
      let!(:portuguese_site_version) { create(:site_version, permalink: 'pt') }

      before(:each) do
        controller.instance_variable_set(:@current_site_version, australian_site_version)
      end

      context 'user request a different site version' do
        it 'updates the current site version with the requested' do
          get :index, { site_version: 'pt' }
          expect(controller.instance_variable_get(:@current_site_version)).to eq(portuguese_site_version)
          expect(cookies[:site_version]).to eq(portuguese_site_version.code)
        end
      end

      context 'user requests the same site version' do
        it 'keep the current site version' do
          get :index, { site_version: 'au' }
          expect(controller.instance_variable_get(:@current_site_version)).to eq(australian_site_version)
          expect(cookies[:site_version]).to eq(australian_site_version.code)
        end
      end
    end
  end
end
