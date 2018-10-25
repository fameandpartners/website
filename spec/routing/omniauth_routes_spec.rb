require 'spec_helper'

describe 'Omniauth routes', type: :routing do

  context 'facebook callback' do
    it 'with omitted site version' do
      expect(get: '/user/auth/facebook/callback').to route_to(
                                                            'controller' => 'spree/omniauth_callbacks',
                                                            'action'     => 'facebook'
                                                        )
    end
  end
end
