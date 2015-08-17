Spree::Core::Engine.routes.draw do
  resources :masterpass do
    post :merchantinitialization
    post :oauthpostback
    post :cart
    get :cartcallback
    post :cartpostback
    post :expresscheckout
    get :expresscheckout
    post :pairingconfiguration
    get :pairingcallback
  end

  # TODO : To implement refund across the masterpass
  namespace :admin do
    # Using :only here so it doesn't redraw those routes
    resources :orders, :only => [] do
      resources :payments, :only => [] do
        member do
          get 'masterpass_refund'
          post 'masterpass_refund'
        end
      end
    end
  end
end
