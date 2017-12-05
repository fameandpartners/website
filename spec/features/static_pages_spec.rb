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
end
