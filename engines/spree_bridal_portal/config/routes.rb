Spree::Core::Engine.routes.draw do
  namespace :bridal_portal, path: 'bridal-portal' do
    root to: 'home#index'
    get 'signup', to: 'registrations#signup'
  end
end
