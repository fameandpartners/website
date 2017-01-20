WeddingAtelier::Engine.routes.draw do
  root to: 'home#index'

  devise_scope :spree_user do
    resource :signup, controller: :registrations, only: [:update, :create] do
      get '/', to: 'registrations#new'
      get '/size', to: 'registrations#size'
      get '/details', to: 'registrations#details'
      get '/invite', to: 'registrations#invite'
    end

    get '/sign_in', to: 'sessions#new'
    post '/sign_in', to: 'sessions#create'
  end

  post '/token', to: 'twilio#token'

  resources :sizing, only: :index

  resources :events do
    resources :invitations, only: :create do
      get '/accept', to: 'invitations#accept'
    end

    resources :customizations, only: :index
    resources :dresses, controller: :event_dresses do
      post '/likes', to: 'likes#create'
      delete '/likes', to: 'likes#destroy'
    end
    resources :assistants, only: [:destroy]
  end

  resources :accounts, path: 'my-account', only: [:index, :update, :show]

  resource :orders, only: [:create, :show]
end
