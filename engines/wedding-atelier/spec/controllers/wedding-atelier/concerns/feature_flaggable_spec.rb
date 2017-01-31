require 'spec_helper'

describe WeddingAtelier::Concerns::FeatureFlaggable, type: :controller do
  controller do
    include WeddingAtelier::Concerns::FeatureFlaggable

    def index
      render text: 'ok!'
    end
  end

  describe 'wedding atelier feature flag' do
    context 'is disabled' do
      before(:each) { Features.deactivate(:wedding_atelier) }

      it 'redirects to the main app root path' do
        get :index

        expect(response).to redirect_to(root_path)
      end
    end

    context 'is enabled' do
      before(:each) { Features.activate(:wedding_atelier) }

      it 'continues to the called controller action' do
        get :index

        expect(response.body).to eq('ok!')
      end
    end
  end
end
