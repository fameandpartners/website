Spree::Core::Engine.routes.draw do
  namespace :bridal_portal, path: 'bridal-portal' do
    root to: 'home#index'
  end
end
