require 'spec_helper'

describe 'Static Pages', type: :request do
  describe 'i=Change LP' do
    context 'i=Change feature flag is on' do
      before(:each) { Features.activate(:i_equal_change) }

      it do
        get '/iequalchange'

        expect(response).to render_template('statics/iequalchange')
      end
    end

    context 'i=Change feature flag is off' do
      before(:each) { Features.deactivate(:i_equal_change) }

      it do
        get '/iequalchange'

        expect(response).to redirect_to('/about')
      end
    end
  end

  describe 'Wedding Atelier LP' do
    context 'user is logged in' do
      let(:user) { FactoryGirl.create(:spree_user) }

      before(:each) { wedding_sign_in(user) }

      it do
        get '/wedding-atelier'

        expect(response).to redirect_to('/wedding-atelier/events')
      end
    end

    context 'user is not logged in' do
      it do
        get '/wedding-atelier'

        expect(response).to render_template('statics/wedding_atelier_app')
      end
    end
  end
end
