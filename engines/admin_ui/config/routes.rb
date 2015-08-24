AdminUi::Engine.routes.draw do
  resources :return_requests
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

  resources :caches, only: [:index, :destroy] do
    delete :expire, :on => :collection
  end

  namespace :content do
    resources :pages
  end

  require 'sidekiq/web'
  mount Sidekiq::Web => 'd0ec826a2968a7079f0bdd8f1116811f'

  root to: 'dashboard#index'
end
