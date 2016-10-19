require 'spec_helper'

describe StaticsController, type: :controller do
  describe '#getitquick_unavailable' do
    it 'expects a 404' do
      get :getitquick_unavailable
      expect(response).to render_template('getitquick_unavailable')
      expect(response).to have_http_status(:not_found)
    end
  end
end
