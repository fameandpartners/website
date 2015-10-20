require 'spec_helper'

describe ApplicationController, :type => :controller do
  controller do
    def index
      render :text => 'ok'
    end

    def create
      render :text => 'ok'
    end
  end

  describe 'before filters' do
    describe 'set_session_country' do

      before do
        allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip).and_return(ip)
        get :index
      end

      context 'UK/GB' do
        let(:ip)   { '217.27.250.160' }
        it 'sets GB' do
          expect(session[:country_code]).to eq 'GB'
        end
      end

      context 'US' do
        let(:ip)   { '74.86.15.72' }
        it 'sets US' do
          expect(session[:country_code]).to eq 'US'
        end
      end

      context 'AU' do
        let(:ip)   { '54.252.112.140' }
        it 'sets AU' do
          expect(session[:country_code]).to eq 'AU'
        end
      end
    end

    describe '#check_site_version' do
      let!(:australian_site_version) { create(:site_version, permalink: 'au') }
      let!(:portuguese_site_version) { create(:site_version, permalink: 'pt') }

      before(:each) do
        controller.instance_variable_set(:@current_site_version, australian_site_version)
      end

      context 'request is a ajax or a non GET' do
        it 'does not changes the site version' do
          post :create, { site_version: 'pt' }
          expect(controller.instance_variable_get(:@current_site_version)).to eq(australian_site_version)

          xhr :get, :index, { site_version: 'pt' }
          expect(controller.instance_variable_get(:@current_site_version)).to eq(australian_site_version)
        end
      end

      context 'user request a different site version' do
        it 'updates the current site version with the requested' do
          get :index, { site_version: 'pt' }
          controller_site_version = controller.instance_variable_get(:@current_site_version)
          expect(controller_site_version).to eq(portuguese_site_version)
        end
      end

      context 'user requests the same site version' do
        it 'keep the current site version' do
          get :index, { site_version: 'au' }
          controller_site_version = controller.instance_variable_get(:@current_site_version)
          expect(controller_site_version).to eq(australian_site_version)
        end
      end
    end
  end
end
