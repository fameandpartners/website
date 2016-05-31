require 'spec_helper'

describe SslRequirement, type: :controller do
  context 'SSL is required by controller' do
    controller do
      include SslRequirement

      ssl_required

      def index
        render text: 'ok'
      end
    end

    before(:each) do
      allow(controller).to receive(:ssl_supported?).and_return(true)
    end

    context 'request is non HTTPS' do
      before(:each) { request.env['HTTPS'] = 'off' }

      it 'redirects to HTTPS' do
        get :index

        expect(response).to redirect_to('https://us.lvh.me/anonymous')
        expect(response).to have_http_status(301)
      end
    end

    context 'request is HTTPS' do
      before(:each) { request.env['HTTPS'] = 'on' }

      it 'does nothing' do
        get :index

        expect(response).to have_http_status(200)
      end
    end
  end
end
