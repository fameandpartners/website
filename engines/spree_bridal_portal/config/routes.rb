Spree::Core::Engine.routes.draw do
  namespace :bridal_portal, path: 'bridal-portal' do
    root to: 'home#index'
    scope '/signup', as: 'signup' do
      get '/', to: 'registrations#signup'
      get '/size', to: 'registrations#size'
      get '/details', to: 'registrations#details'
      get '/invite', to: 'registrations#invite'
    end
  end
end
