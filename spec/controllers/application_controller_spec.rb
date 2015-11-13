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
  end
end
