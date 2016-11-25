Spree::Core::Engine.routes.draw do
  namespace :wedding_atelier, path: 'wedding-atelier' do
    root to: 'home#index'

    devise_scope :spree_user do
      resource :signup, controller: :registrations, only: [:update, :create] do
        get '/', to: 'registrations#new'
        get '/size', to: 'registrations#size'
        get '/details', to: 'registrations#details'
        get '/invite', to: 'registrations#invite'
        post '/send_invites', to: 'registrations#send_invites'
      end

      get '/sign_in', to: 'sessions#new'
      post '/sign_in', to: 'sessions#create'
    end

    resources :events
  end
end
