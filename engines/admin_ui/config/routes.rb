AdminUi::Engine.routes.draw do
  resources :item_returns do
    get ':event_type/new', :controller => 'item_returns/events', action: :new, as: :build_event
    resources :events, :controller => 'item_returns/events', except: [:update, :delete]
  end

  resources :preferences, only: :index do
    collection do
      put 'update'
    end
  end

  namespace :backend do
    resources :caches, only: [:index, :destroy, :show] do
      delete :expire, :on => :collection
    end

    resources :product_indexes, only: [:index, :show] do
      delete :clear, :on => :collection
    end

    resources :manually_managed_returns
    resources :return_requests

    resource :sidekiq, only: :show do
      require 'sidekiq/web'
      mount Sidekiq::Web => 'd0ec826a2968a7079f0bdd8f1116811f'
    end

    resources :features, only: [:index] do
      collection do
        get :enable
        get :disable
      end
    end
  end

  resources :refund_requests, only: [:index, :update]
  resources :return_requests_reports, only: [:index]

  namespace :reports do
    root to: 'dashboard#index'
    resource :body_shape_calculator_results, only: [:show, :create]
    resource :coupon_adjusted_orders       , only: [:show, :create]
    resource :factory_faults               , only: [:show, :create]
    resource :order_totals                 , only: [:show, :create]
    resource :payments                     , only: [:show, :create]
    resource :product_numbers              , only: [:show, :create]
    resource :return_shoppers              , only: [:show, :create]
    resource :sale_items                   , only: [:show, :create]
    resource :size_normalisations          , only: [:show]
    resource :daily_orders                 , only: [:show, :create]
  end

  resources :variants
  resources :product_colors do
    collection do
      get 'colors_options/:product_id' => 'product_colors#colors_options_json'
    end
  end

  namespace :content do
    resources :pages
  end

  root to: 'dashboard#index'

  mount ManualOrder::Engine, at: '/'

end
