AdminUi::Engine.routes.draw do
  resources :item_returns do
    get ':event_type/new', :controller => 'item_returns/events', action: :new, as: :build_event
    resources :events, :controller => 'item_returns/events', except: [:update, :delete]

    collection do
      get :weekly_refund, action: :index, scope: :refund_queue
      get ':item_return_id/label', action: :generate_new_return_label
      get ':item_return_id/autorefund/enable', action: :enable_autorefund
      get ':item_return_id/autorefund/disable', action: :disable_autorefund
      post :bulk_refund_process
    end
  end

  resources :redirected_search_terms
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
      mount Sidekiq::Web => 'd0ec826a2968a7079f0bdd8f1116811f', as: :web_backend
    end

    resources :features, only: [:index] do
      collection do
        get :enable
        get :disable
      end
    end
  end

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
    resource :refunds                      , only: [:show]
  end

  namespace :content do
    resources :pages
    resources :contentful
    resources :upc, only: [:index, :new, :create]
    post 'contentful_route' => 'contentful#create_route'
  end

  namespace :logistics do
    resources :bergen, only: [:index] do
      member do
        get 'retry'
      end
    end

    resources :next, only: [:index] do
      member do
        get 'retry'
      end
    end

    resources :upload
    post 'upload/create_upload' => 'upload#create_upload'
  end

  namespace :customisation do
    resources :customisation_values do
      collection do
        get 'option_values/:product_id' => 'customisation_values#option_values'
      end
    end
    resources :variants
    resources :render3d_images do
      collection do
        get 'option_values/:product_id' => 'render3d_images#option_values', as: 'option_values'
      end
    end

    resources :product_colors do
      collection do
        get 'colors_options/:product_id' => 'product_colors#colors_options_json'
      end
    end
  end

  root to: 'dashboard#index'

  mount ManualOrder::Engine, at: '/'

end
