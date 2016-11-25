Spree::Core::Engine.routes.draw do
  namespace :wedding_atelier, path: 'wedding-atelier' do
    root to: 'home#index'

    devise_scope :spree_user do
      resource :signup, controller: :registrations, except: [:destroy, :edit, :show] do
        get '/size', to: 'registrations#size'
        get '/details', to: 'registrations#details'
        get '/invite', to: 'registrations#invite'
        post '/send_invites', to: 'registrations#send_invites'
      end
    end

    resources :events
  end
end
