AdminUi::Engine.routes.draw do
  resources :return_requests
  resources :item_returns do

    get ':event_type/new', :controller => 'return_approvals/events', action: :new, as: :build_event
    resources :events, :controller => 'return_approvals/events', except: [:update, :delete]
  end

  resources :preferences, only: :index do
    collection do
      put 'update'
    end
  end

  namespace :reports do
    root to: 'dashboard#index'
    resource :payments,               :only => [:show, :create]
    resource :sale_items,             :only => [:show, :create]
    resource :coupon_adjusted_orders, :only => [:show, :create]
    resource :order_totals,           :only => [:show, :create]
    resource :return_shoppers,        :only => [:show, :create]
  end

  resources :caches, only: [:index, :destroy, :show] do
    delete :expire, :on => :collection
  end

  resources :product_indexes, only: [:index, :show] do
    delete :clear, :on => :collection
  end

  namespace :content do
    resources :pages
  end

  resource :sidekiq, :only => :show do
    require 'sidekiq/web'
    mount Sidekiq::Web => 'd0ec826a2968a7079f0bdd8f1116811f'
  end

  root to: 'dashboard#index'
end
