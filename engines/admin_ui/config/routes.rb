AdminUi::Engine.routes.draw do
  resources :return_requests
  resource  :payments_report,    :only => [:show, :create]

  namespace :reports do
    resource :sale_items, :only => [:show, :create]
  end

  resources :caches, only: [:index, :destroy] do
    delete :expire, :on => :collection
  end


  require 'sidekiq/web'
  mount Sidekiq::Web => 'd0ec826a2968a7079f0bdd8f1116811f'

  root to: 'dashboard#index'
end
