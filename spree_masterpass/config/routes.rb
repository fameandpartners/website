Spree::Core::Engine.routes.draw do
  scope "(:site_version)", constraints: { site_version: /(us|au)/ } do
    resources :masterpass do
      collection do
        get 'cart'
        get 'cartcallback'

        # post 'merchantinitialization'
        # post 'oauthpostback'
        # post 'cartpostback'
        # post 'expresscheckout'
        # get 'expresscheckout'
        # post 'pairingconfiguration'
        # get 'pairingcallback'
      end
    end

    # TODO : To implement refund across the masterpass & filter by masterpass payment method
    # namespace :admin do
    #   # Using :only here so it doesn't redraw those routes
    #   resources :orders, :only => [] do
    #     resources :payments, :only => [] do
    #       member do
    #         get 'masterpass_refund'
    #         post 'masterpass_refund'
    #       end
    #     end
    #   end
    # end
  end
end
