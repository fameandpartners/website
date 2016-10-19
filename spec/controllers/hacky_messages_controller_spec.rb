require 'spec_helper'

describe HackyMessagesController, type: :controller do
  describe '#getitquick_unavailable' do
    # collection resource does not matter
    before(:each) { allow(Products::CollectionResource).to receive_message_chain(:new, :read) }

    it 'expects a 404' do
      get :getitquick_unavailable
      expect(response).to render_template(:getitquick_unavailable)
      expect(response).to have_http_status(:not_found)
    end
  end
end
